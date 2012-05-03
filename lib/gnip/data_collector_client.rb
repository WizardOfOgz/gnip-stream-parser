require 'eventmachine'
require 'em-http'

module Gnip
  class DataCollectorClient < Client

    # Streams chunked data from Gnip and yields XML entries to the provided block
    def stream(&block)
      raise "No block provided for call to #{self.class.name}#stream" unless block_given?

      buffer = ''
      entry = ''

      loop do
        Curl::Easy.http_get @url do |c|
          c.http_auth_types = :basic
          c.username = @username
          c.password = @password
          c.encoding = 'gzip'
          c.on_body do |chunk|

            buffer += chunk
            while line = buffer.slice!(/.+\r?\n/)
              entry << line
              if line.match(/<\/entry>/)
                yield entry
                entry = ''
              end
            end

            chunk.size
          end
        end

        sleep(0.25) # Need to implement an exponential backoff pattern *
      end
    end
  end
end
