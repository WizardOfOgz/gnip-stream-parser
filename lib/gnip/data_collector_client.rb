require 'eventmachine'
require 'em-http'

module Gnip
  class DataCollectorClient < Client

    # Streams and parses data from Gnip.  Once an entire activity stream object (JSON) has been parsed, the
    # resulting hash will be passed as an argument to the given block.
    def stream
      raise "No block provided for call to #{self.class.name}#stream" unless block_given?

      loop do
        # run the EventMachine reactor, this call will block until 
        # EventMachine.stop is called
        EventMachine.run do
          http = EventMachine::HttpRequest.new(@url).get :head => {'authorization' => [@username, @password]}
          buffer = ''
          entry = ''
          http.stream do |chunk|
            buffer += chunk
            while line = buffer.slice!(/.+\r?\n/)
              entry << line
              if line.match(/<\/entry>/)
                yield SergioActivityStreamPost.new(entry).to_json_activity_stream_hash
                entry = ''
              end
            end
          end

          # when the HTTP request is done, stop EventMachine
          http.callback { EventMachine.stop }
        end
        sleep(0.25)
      end

    end

  end
end
