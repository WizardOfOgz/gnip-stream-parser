require 'spec_helper'

describe "Client" do
  let(:client) {Gnip::Client.new("https://example.com/stream.json","User","Password") }

  context "#new" do
    it "raises exception when username is blank" do
      lambda{
        Gnip::Client.new("https://example.com/stream.json",nil,"Password")
      }.should raise_error("No username provided for call to Gnip::Client#new")
    end

    it "raises exception when password is blank" do
      lambda{
        Gnip::Client.new("https://example.com/stream.json", "User", nil)
      }.should raise_error("No password provided for call to Gnip::Client#new")
    end

    it "raises exception when url is blank" do
      lambda{
        Gnip::Client.new(nil,"User","Password")
      }.should raise_error("No URL provided for call to Gnip::Client#new")
    end

    it "sets username" do
      client.instance_variable_get(:@username).should eq("User")
    end

    it "sets username" do
      client.instance_variable_get(:@password).should eq("Password")
    end

    it "sets username" do
      client.instance_variable_get(:@url).should eq("https://example.com/stream.json")
    end
  end

end
