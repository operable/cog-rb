class Cog
  class Services
    class Chat < Cog::Service
      VERSION = "1.0.0"

      class << self
        def send_message(destination, message)
          payload = { "destination" => destination, "message" => message }.to_json
          post(path: "send_message", data: payload)
        end
      end
    end
  end
end
