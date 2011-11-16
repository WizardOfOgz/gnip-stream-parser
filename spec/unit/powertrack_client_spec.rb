require 'spec_helper'

describe "PowertrackClient" do
  let(:powertrack_client) {Gnip::PowertrackClient.new("https://example.com/stream.json","User","Password") }

  context "#stream" do
    it "raises exception when no block is passed" do
      lambda{
        powertrack_client.stream
      }.should raise_error("No block provided for call to Gnip::PowertrackClient#stream")
    end
  end

end
