require 'yaml'
require 'securerandom'
require 'rspec/core'

class Cog
  module RSpec
    module Setup
      extend ::RSpec::SharedContext

      before(:each) do
        # Ensure a clean ENV, as far as Cog cares
        # NOTE: Does not do anything pertaining to dynamic config
        # variables yet
        ENV.delete_if{|name, value| name.start_with?("COG_")}
      end

      let(:base_dir) do
        # Cog Ruby commands expect to be run from a script in the
        # top-level directory. This code thus assumes that the tests are
        # being run from that same top-level directory.
        File.absolute_path(Dir.pwd)
      end

      let(:config_file) do
        File.join(base_dir, "config.yaml")
      end

      let(:bundle_name) do
        # Read the bundle name from the bundle configuration; no need to
        # repeat that everywhere
        YAML.load(File.read(config_file))["name"]
      end

      let!(:bundle) do
        # This is `let!` instead of `let` because this call actually
        # *creates* the bundle module that our commands live in; we want
        # to ensure that this gets called before we start doing anything else
        Cog::Bundle.new(bundle_name, base_dir: base_dir)
      end

      let(:command_name){ raise "Must supply a :command_name!" }

      let(:command) do
        bundle.command_instance(command_name)
      end

      let(:invocation_id) { SecureRandom.uuid }

      let(:service_root) { "http://localhost:4002" }

      let(:cog_env) { [] }

      def run_command(args: [], options: {})
        ENV["COG_COMMAND"]       = command_name
        ENV["COG_INVOCATION_ID"] = invocation_id
        ENV["COG_SERVICES_ROOT"] = service_root

        # populate arguments
        ENV["COG_ARGC"] = args.size.to_s
        args.each_with_index{|arg, i| ENV["COG_ARGV_#{i}"] = arg.to_s}

        # populate_options
        if !options.keys.empty?
          ENV["COG_OPTS"] = options.keys.join(",")

          options.each do |key, value|
            name = key.upcase

            if value.is_a?(Enumerable)
              ENV["COG_OPT_#{name}_COUNT"] = value.count.to_s

              value.each_with_index do |v, i|
                ENV["COG_OPT_#{name}_#{i}"] = v
              end
            else
              ENV["COG_OPT_#{name}"] = value.to_s
            end
          end
        end

        # TODO: receive a single input on request(:input) and
        #       multiple for :fetch_input

        # Expose previous inputs on request.input
        # We use allow because not all commands receive input
        allow(command.request).to receive(:input).and_return(cog_env)

        # Use allow because not all commands will need to do this
        allow(command).to receive(:fetch_input).and_return(cog_env)
        command.run_command
      end
    end
  end
end
