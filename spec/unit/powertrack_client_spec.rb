require 'spec_helper'

describe "PowertrackClient" do
  let(:powertrack_client) {Gnip::PowertrackClient.new("https://example.com/stream.json","User","Password") }

  context "#new" do
    it "raises exception when username is blank" do
      lambda{
        Gnip::PowertrackClient.new("https://example.com/stream.json",nil,"Password")
      }.should raise_error("No username provided for call to Gnip::PowertrackClient#stream")
    end

    it "raises exception when password is blank" do
      lambda{
        Gnip::PowertrackClient.new("https://example.com/stream.json", "User", nil)
      }.should raise_error("No password provided for call to Gnip::PowertrackClient#stream")
    end

    it "raises exception when url is blank" do
      lambda{
        Gnip::PowertrackClient.new(nil,"User","Password")
      }.should raise_error("No URL provided for call to Gnip::PowertrackClient#stream")
    end

    it "sets username" do
      powertrack_client.instance_variable_get(:@username).should eq("User")
    end

    it "sets username" do
      powertrack_client.instance_variable_get(:@password).should eq("Password")
    end

    it "sets username" do
      powertrack_client.instance_variable_get(:@url).should eq("https://example.com/stream.json")
    end
  end

  context "#stream" do
    it "raises exception when no block is passed" do
      lambda{
        powertrack_client.stream
      }.should raise_error("No block provided for call to Gnip::PowertrackClient#stream")
    end
  end

end
