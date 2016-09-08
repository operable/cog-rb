class Cog
  class Bundle
    attr_reader :name, :config

    def initialize(name, base_dir: nil, config_file: nil)
      @name = name
      @base_dir = base_dir || File.dirname($0)
      @config = load_config(config_file || File.join(@base_dir, 'config.yaml'))
      @module = create_bundle_module

      load_commands
    end

    def create_bundle_module
      return if Object.const_defined?('CogCmd')

      Object.const_set('CogCmd', Module.new)
      CogCmd.const_set(@name.capitalize, Module.new)
    end

    def load_config(path=nil)
      path ||= File.join(@base_dir, 'config.yaml')
      Cog::Config.new(path)
    end

    def load_commands
      @config[:commands].each do |command, config|
        command_path = command.split('-')
        require File.join(@base_dir, 'lib', 'cog_cmd', @name, *command_path)
      end
    end

    def run_command
      command = ENV['COG_COMMAND']

      # translate snake-case command names to camel case
      command_class = command.gsub(/(\A|_)([a-z])/) { $2.upcase }

      # convert hyphenated command names into class hierarchies,
      # e.g. template-list becomes Template::List.
      command_class = command_class.split('-').map{ |seg| seg.capitalize }.join('::')

      target = @module.const_get(command_class).new
      target.execute
    # Abort will end command execution and abort the pipeline
    rescue Cog::Abort => msg
      response = Cog::Response.new
      response['body'] = msg
      response.abort
      response.send
    # Stop will end command execution but the pipeline will continue
    rescue Cog::Stop => msg
      response = Cog::Response.new
      response['body'] = msg
      response.send
    end
  end
end
