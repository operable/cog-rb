require 'cog/exceptions'

class Cog
  class AggregateCommand < Cog::Command

    def initialize
      subcommands = self.class.const_get("SUBCOMMANDS")
      subcommand = request.args.shift

      require_subcommand!(subcommand, subcommands)

      load_subcommands(subcommands)

      @subcommand_class = create_subcommand_class(subcommand)
    end

    def run_command
      subcommand.execute
    end

    private

    def subcommand
      @subcommand_inst ||= @subcommand_class.new
    end

    def load_subcommands(subcommands)
      subcommands.each do |sc|
        require File.join(File.dirname($0), 'lib', 'cog_cmd', ENV['COG_BUNDLE'], ENV['COG_COMMAND'], sc)
      end
    end

    def create_subcommand_class(subcommand)
      subcommand_class = subcommand.gsub(/(\A|_)([a-z])/) { $2.upcase }
      self.class.const_get(subcommand_class)
    end

    def require_subcommand!(subcommand, subcommands, exception = Cog::Abort)
      unless subcommand
        raise exception, missing_subcommand_msg(subcommands)
      end

      unless subcommands.include?(subcommand)
        raise exception, unknown_subcommand_msg(subcommand, subcommands)
      end
    end

    def missing_subcommand_msg(subcommands)
      "Missing subcommand. Please specify one of '#{subcommands.join(', ')}'"
    end

    def unknown_subcommand_msg(subcommand, subcommands)
      "Unknown subcommand '#{subcommand}'. Please specify one of '#{subcommands.join(', ')}'"
    end
  end
end
