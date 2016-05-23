
require "yaml"

class Cog
  class Config
    def initialize(config_file)
      @config = YAML.load(File.read(config_file))
    end

    def dump
      YAML.dump(@config)
    end

    def [](key)
      @config[key.to_s]
    end
  end
end
