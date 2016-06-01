class Cog
  class Services
    class Memory < Cog::Service
      VERSION = "1.0.0"

      class << self
        def accum(key, value)
          post(path: key, data: { "op" => "accum", "value" => value }.to_json)
        end

        def replace(key, value)
          put(path: key, data: value.to_s)
        end
      end
    end
  end
end
