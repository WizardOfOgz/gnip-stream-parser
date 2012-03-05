require 'yajl'
require 'uri'
require 'curb'

module Gnip
  class PowertrackClient < Client

    # Streams and parses data from Gnip.  Once an entire activity stream object (JSON) has been parsed, the
    # resulting hash will be passed as an argument to the given block.
    def stream(&block)
      raise "No block provided for call to #{self.class.name}#stream" unless block_given?

      # Parser to handle JSON data streamed from Gnip.  Must handle chunked data.
      parser = Yajl::Parser.new
      parser.on_parse_complete = block

      loop do

        Curl::Easy.http_get @url do |c|
          c.http_auth_types = :basic
          c.username = @username
          c.password = @password
          c.encoding = 'gzip'
          c.on_body do |data|
            parser << data
            data.size
          end
        end

        sleep(0.25) # Need to implement an exponential backoff pattern *
      end
    end

  end
end
