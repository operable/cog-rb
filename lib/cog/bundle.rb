class Cog
  class Bundle
    attr_reader :name

    def initialize(name, base_dir: nil)
      @name = name
      @base_dir = base_dir || File.dirname($0)
      @module = create_bundle_module
    end

    def create_bundle_module
      return if Object.const_defined?('CogCmd')
      Object.const_set('CogCmd', Module.new)
      CogCmd.const_set(@name.capitalize, Module.new)
    end

    def command_instance(command_name)
      command_path = command_name.split('-')
      require File.join(@base_dir, 'lib', 'cog_cmd', @name, *command_path)

      # translate snake-case command names to camel case
      command_class = command_name.gsub(/(\A|_)([a-z])/) { $2.upcase }

      # convert hyphenated command names into class hierarchies,
      # e.g. template-list becomes Template::List.
      command_class = command_class.split('-').map{ |seg| seg.capitalize }.join('::')

      @module.const_get(command_class).new
    end

    def run_command
      command = ENV['COG_COMMAND']
      target = command_instance(command)
      target.execute
    rescue Cog::Abort => msg
      # Abort will end command execution and abort the pipeline
      response = Cog::Response.new
      response['body'] = msg
      response.abort
      response.send
    rescue Cog::Stop => msg
      # Stop will end command execution but the pipeline will continue
      response = Cog::Response.new
      response['body'] = msg
      response.send
    end

  end
end
