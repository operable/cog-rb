
require "yaml"

class Cog
  class Config
    attr_reader :config_file, :data, :stale

    def initialize(config_file)
      @config_file = config_file
      @data = YAML.load(File.read(@config_file))
      @stale = false
    end

    def dump
      YAML.dump(@data)
    end

    def [](key)
      @data[key.to_s]
    end

    def []=(key, value)
      @data[key.to_s] = value
      @stale = true
    end

    def update_version(version = nil)
      if !version.nil?
        @data[version] = version
      else
        segments = @data['version'].split('.')
        segments[-1] = segments.last.to_i + 1
        @data['version'] = segments.join('.')
      end
    end

    def save
      return unless @stale

      contents = YAML.dump(@data)
      File.open(@config_file, 'w') do |out|
        out.write(contents)
        @stale = false
      end
    end

    def stale?
      @stale
    end
  end
end
