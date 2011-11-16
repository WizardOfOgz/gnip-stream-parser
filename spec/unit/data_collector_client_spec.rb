require 'spec_helper'

describe "DataCollectorClient" do
  let(:data_collector_client) {Gnip::DataCollectorClient.new("User","Password","https://example.com/stream.json") }

  context "#stream" do
    it "raises exception when no block is passed" do
      lambda{
        data_collector_client.stream
      }.should raise_error("No block provided for call to Gnip::DataCollectorClient#stream")
    end
  end

end
