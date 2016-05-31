
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
      return if content.nil?

      write "COG_TEMPLATE: #{@template}" unless @template.nil?

      case content.class
      when String
        write @content.join('').to_json
      else
        write "JSON\n" + @content.to_json
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
        level = :info unless LOG_LEVELS.include?(:level)
        write "COGCMD_#{level.to_s.upcase}: #{message}"
      end
    end
  end
end
