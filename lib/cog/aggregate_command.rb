require 'cog/exceptions'

class Cog
  class AggregateCommand < Cog::Command

    def initialize
      subcommands = self.class.const_get("SUBCOMMANDS")

      unless subcommand = request.args.shift
        no_subcommand_error
        response.abort
        return
      end

      unless subcommands.include?(subcommand)
        unknown_subcommand_error(subcommand, subcommands)
        response.abort
        return
      end

      load_subcommands(subcommands)

      @subcommand_class = create_subcommand_class(subcommand)
    end

    def run_command
      return if response.aborted
      response.content = subcommand().run_command
    end

    private

    def subcommand
      @subcommand_inst ||= @subcommand_class.new(request)
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

    def no_subcommand_error
      raise Cog::Error, "Subcommand required", caller
    end

    def unknown_subcommand_error(subcommand, subcommands)
      raise Cog::Error, "Unknown subcommand '#{subcommand}'. Please specify one of '#{subcommands.join(', ')}'", caller
    end
  end
end

