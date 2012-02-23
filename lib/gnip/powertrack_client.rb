require 'yajl'
require 'uri'
require 'net/http'
require 'em-http-request'


# Lifted from https://gist.github.com/1468622
#-------------------------------------------------------------------------------------------------------
# Monkey-patched Gzip Decoder to handle
# Gzip streams.
#
# This takes advantage of the fact that
# Zlib::GzipReader takes an IO object &
# reads from it as it decompresses.
#
# It also relies on Zlib only checking for
# nil as the method of determining whether
# it has reached EOF.
#
# `IO#read(len, buf)` can also denote EOF by returning a string
# shorter than `len`, but Zlib doesn't care about that.
#
module EventMachine::HttpDecoders
  class GZip < Base
    class LazyStringIO
      def initialize string=""
        @stream=string        
      end

      def << string
        @stream << string
      end

      def read length=nil,buffer=nil
        buffer||=""
        length||=0
        buffer << @stream[0..(length-1)]
        @stream = @stream[length..-1]
        buffer
      end
      
      def size
        @stream.size
      end
    end

    def self.encoding_names
      %w(gzip compressed)
    end

    def decompress(compressed)
      @buf ||= LazyStringIO.new
      @buf << compressed
      
       # Zlib::GzipReader loads input in 2048 byte chunks
      if @buf.size > 2048
        @gzip ||= Zlib::GzipReader.new @buf
        @gzip.readline # lines are bigger than compressed chunks, so this works
                       # you could also use #readpartial, but then you need to tune
                       # the max length
                       # don't use #read, because it will attempt to read the full file
                       # readline uses #gets under the covers, so you could try that too.
      end
    end

    def finalize
      @gzip.read
    end
  end
end
#-------------------------------------------------------------------------------------------------------



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
        # run the EventMachine reactor, this call will block until 
        # EventMachine.stop is called
        EventMachine.run do
          http = EventMachine::HttpRequest.new(@url).get :head => {'Authorization' => [@username, @password], "Accept-Encoding" => "gzip"}

          http.headers do |hash|
            p [:status, http.response_header.status]
            p [:headers, hash]
            if http.response_header.status > 299
              puts 'unsuccessful request'
              EM.stop
            end
          end

          http.stream do |chunk|
            parser << chunk
          end

          # when the HTTP request is done, stop EventMachine
          http.callback { EventMachine.stop }
        end
        sleep(0.25)
      end
    end

  end
end
