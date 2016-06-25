
require 'json'

class Cog
  class Response
    LOG_LEVELS = [ :debug, :info, :warn, :err, :error ]

    attr_accessor :template, :content

    def []=(key, value)
      @content ||= {}
      @content[key] = value
    end

    def send
      unless @log_msgs.nil?
        for log_msg in @log_msgs do
          write log_msg
        end
      end

      if content.nil?
        write ""
        return
      end

      write "COG_TEMPLATE: #{@template}" unless @template.nil?

      case content.class
      when String
        write ""
        write @content.join('').to_json
      else
        write "JSON"
        write ""
        write @content.to_json
      end
    end

    def write(message)
      self.class.write(message)
    end

    def log(level, message)
      self.class.log(level, message)
    end

    class << self
      def write(message)
        puts message
        STDOUT.flush
      end

      def log(level, message)
        @log_msgs ||= []
        level = LOG_LEVELS.include?(level) ? level : :info
        @log_msgs.push "COGCMD_#{level.to_s.upcase}: #{message}"
      end
    end
  end
end
