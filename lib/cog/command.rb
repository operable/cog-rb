
require 'json'

class Cog
  class Command
    attr_writer :memory_key, :config

    def request
      @request ||= Cog::Request.new
    end

    def response
      @response ||= Cog::Response.new
    end

    def memory_key
      @memory_key ||= ENV['COG_INVOCATION_ID']
    end

    def config
      @config ||= { input: self.class.input }
    end

    def step
      step = ENV['COG_INVOCATION_STEP']
      step.nil? ? nil : step.to_sym
    end

    def accumulate_input
      Cog::Services::Memory.accum(memory_key, request.input)
    end

    def fetch_input
      JSON.parse(Cog::Services::Memory.get(memory_key))
    end

    def execute
      accumulate_input if config[:input] == :accumulate
      run_command
      response.send
    end

    def env_var(var, suffix: nil, required: true, failure_message: nil)
      key = suffix ? "#{var}_#{suffix}" : var
      value = ENV[key]

      if required and value.nil?
        message = failure_message ? failure_message : "Required environment variable #{key} missing!"
        fail(message)
      else
        value
      end
    end

    def fail(message)
      STDERR.puts(message)
      exit 1
    end

    def self.input(value=nil)
      return @input if value.nil?
      @input = value
    end
  end
end
