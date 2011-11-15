require 'yajl'
require 'uri'
require 'net/http'

module Gnip
  class PowertrackClient

    def initialize(url, username, password)
      raise "No username provided for call to #{self.class.name}#stream" if (username.nil? || (username.respond_to?(:empty?) && username.empty?))
      raise "No password provided for call to #{self.class.name}#stream" if (password.nil? || (password.respond_to?(:empty?) && password.empty?))
      raise "No URL provided for call to #{self.class.name}#stream" if (url.nil? || (url.respond_to?(:empty?) && url.empty?))

      @username = username
      @password = password
      @url = url
    end

    # Streams and parses data from Gnip.  Once an entire activity stream object (JSON) has been parsed, the
    # resulting hash will be passed as an argument to the given block.
    def stream(&block)
      raise "No block provided for call to #{self.class.name}#stream" unless block_given?
  
      loop do
        # Make authentication request and initialize PowerTrack session.
        # Gnip session tokens expire after 2 minutes, so if a connection is lost it is likely that re-authentication is necessary.
        auth_uri = URI.parse(@url)

        http = Net::HTTP.new(auth_uri.host, auth_uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        auth_request = Net::HTTP::Get.new(auth_uri.request_uri)
        auth_request.basic_auth @username, @password
        auth_response = http.request(auth_request)

        # Get session token from response
        power_track_session_token = auth_response['Set-Cookie'].scan(/session_token=[a-f0-9-]*/).first
    
        # Get URI for Power Track stream
        stream_uri = URI.parse(auth_response["location"])

        # Parser to handle JSON data streamed from Gnip.  Must handle chunked data.
        parser = Yajl::Parser.new
        parser.on_parse_complete = block

        # Stream Power Track data and feed it to the parser
        http = Net::HTTP.new(stream_uri.host, stream_uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.request_get(stream_uri.path, {"Cookie" => power_track_session_token}) do |response|
          response.read_body do |chunk|
            parser << chunk
          end
        end

        # If connection is closed, wait and then loop to reconnect.  This process should continue indefinitely
        sleep(0.25)
      end
    end

  end
end
