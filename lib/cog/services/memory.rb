class Cog
  class Services
    class Memory < Cog::Service
      VERSION = "1.0.0"

      class << self
        def data(op, value)
          { "op" => op.to_s, "value" => value }
        end

        def accum(key, value)
          post(path: key, data: data(:accum, value))
        end

        def replace(key, value)
          put(path: key, data: data(:replace, value))
        end
      end
    end
  end
end
