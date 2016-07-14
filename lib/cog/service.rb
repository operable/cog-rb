
require 'net/http'

class Cog
  class Service
    class << self
      def headers
        {
          "Authorization" => "pipeline #{ENV['COG_SERVICE_TOKEN']}",
          "Content-Type"  => "application/json"
        }
      end

      def uri_for(path=nil)
        service_path =
          if path.class == URI::HTTP
            path
          else
            [ service_name, version, path ].compact.join('/')
          end

        URI(ENV['COG_SERVICES_ROOT'] + '/v1/services/' + service_path)
      end

      def service_name
        get_const('SERVICE_NAME', self.to_s.split('::').last.downcase)
      end

      def version
        get_const('VERSION')
      end

      def get(path=nil)
        uri = uri_for(path)
        res = Net::HTTP.start(uri.host, uri.port,
                              :use_ssl => uri.scheme == 'https') do |http|
          req = Net::HTTP::Get.new(uri)
          headers.each { |k,v| req[k] = v }
          http.request(req)
        end

        res.body
      end

      def post(path: nil, data: nil)
        put_or_post(:post, path: path, data: data)
      end

      def put(path: nil, data: nil)
        put_or_post(:put, path: path, data: data)
      end

      private

      def get_const(name, default=nil)
        self.const_defined?(name) ? self.const_get(name) : default
      end

      def put_or_post(type, path: nil, data: nil)
        uri = uri_for(path)
        http_class = (type == :post) ? Net::HTTP::Post : Net::HTTP::Put
        req = http_class.new(uri, headers)
        req.body = data

        res = Net::HTTP.start(uri.host, uri.port,
                              :use_ssl => uri.scheme == 'https') do |http|
          http.request(req)
        end
      end
    end
  end
end
