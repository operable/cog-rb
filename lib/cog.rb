
require_relative 'cog/bundle'
require_relative 'cog/config'
require_relative 'cog/command'
require_relative 'cog/exception_handler'
require_relative 'cog/request'
require_relative 'cog/response'
require_relative 'cog/version'

require_relative 'cog/service'
require_relative 'cog/services/memory'
require_relative 'cog/services/metadata'

class Cog
  def self.bundle(name)
    bundle = Cog::Bundle.new(name)
    yield bundle if block_given?

    begin
      bundle.run_command
    rescue Exception => ex
      error_handler.handle_exception(
        exception: ex,
        command: bundle.command
      )
    end
  end

  def self.error_handler
    @@handler ||= Cog::ExceptionHandler.new
  end

  def self.return_error(message)
    puts "COGCMD_ACTION: abort"
    puts message
    exit(0)
  end
end
