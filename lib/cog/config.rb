
require "yaml"

class Cog
  class Config
    attr_reader :config_file, :yaml, :data

    def initialize(config_file)
      @config_file = config_file
      @yaml = File.read(@config_file)
      @data = YAML.load(@yaml)
    end

    def dump
      YAML.dump(@data)
    end

    def [](key)
      @data[key.to_s]
    end

    def []=(key, value)
      @data[key.to_s] = value
    end

    def update_version(version = nil)
      if !version.nil?
        @data[version] = version
      else
        segments = @data['version'].split('.')
        segments[-1] = segments.last.to_i + 1
        @data['version'] = segments.join('.')
      end

      @data['version']
    end

    def save
      return unless self.stale?

      contents = YAML.dump(@data)
      File.open(@config_file, 'w') do |out|
        out.write(contents)
      end
    end

    def stale?
      @yaml != YAML.dump(@data)
    end
  end
end
