require 'yajl'
require 'uri'
require 'net/http'

module Gnip
  class Client

    def initialize(url, username, password)
      raise "No username provided for call to #{self.class.name}#new" if (username.nil? || (username.respond_to?(:empty?) && username.empty?))
      raise "No password provided for call to #{self.class.name}#new" if (password.nil? || (password.respond_to?(:empty?) && password.empty?))
      raise "No URL provided for call to #{self.class.name}#new" if (url.nil? || (url.respond_to?(:empty?) && url.empty?))

      @username = username
      @password = password
      @url = url
    end

  end
end
