class Cog::ExceptionHandler
  attr_accessor :handlers

  def initialize
    @handlers = {}
  end

  def add(pattern, &block)
    @handlers[pattern] = block
  end

  def handle_exception(exception:, command:)
    handlers.keys.each do |pattern|
      if pattern.match(exception.class.to_s)
        log_exception(exception, command)
        handlers[pattern].call(exception, command)
        return
      end
    end

    raise exception
  end

  private

  def log_exception(exception, command)
    log_message = {
      command_name: command.name,
      message: exception.message,
      stack_trace: exception.backtrace
    }
    puts "COGCMD_ERROR: #{log_message.to_json}"
  end
end
