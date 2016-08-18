
require 'json'

class Cog
  class Request
    attr_reader :options, :args, :input

    def initialize
      @args = populate_args
      @options = populate_options
      @input = JSON.parse(STDIN.read)
    end

    private

    def populate_args
      (0 .. (ENV['COG_ARGC'].to_i - 1)).map { |n| ENV["COG_ARGV_#{n}"] }
    end

    def populate_options
      return {} if ENV['COG_OPTS'].nil?

      options = ENV["COG_OPTS"].split(",")
      Hash[options.map { |opt| [ opt, opt_val(opt) ] }]
    end

    # Returns the value of option env var specified by 'opt'. If option is
    # a list it will include a count. In that case we return an array of values.
    def opt_val(opt)
      count = ENV["COG_OPT_#{opt.upcase}_COUNT"].to_i
      if count
        count.to_i.times.map { |i| ENV["COG_OPT_#{opt.upcase}_#{i}"] }
      else
        ENV["COG_OPT_#{opt.upcase}"]
      end
    end
  end
end
