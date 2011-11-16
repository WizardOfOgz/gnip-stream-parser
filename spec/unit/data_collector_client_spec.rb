# require 'spec_helper'

# describe "DataCollectorStreamer" do
#   let(:data_collector_streamer) {Gnip::DataCollectorStreamer.new("User","Password","https://example.com/stream.json") }

#   context "#new" do
#     it "raises exception when username is blank" do
#       lambda{
#         Gnip::DataCollectorStreamer.new(nil,"Password","https://example.com/stream.json")
#       }.should raise_error("No username provided for call to Gnip::PowertrackStreamer#stream")
#     end

#     it "raises exception when password is blank" do
#       lambda{
#         Gnip::DataCollectorStreamer.new("User", nil,"https://example.com/stream.json")
#       }.should raise_error("No password provided for call to Gnip::PowertrackStreamer#stream")
#     end

#     it "raises exception when url is blank" do
#       lambda{
#         Gnip::DataCollectorStreamer.new("User","Password",nil)
#       }.should raise_error("No URL provided for call to Gnip::PowertrackStreamer#stream")
#     end

#     it "sets username" do
#       data_collector_streamer.instance_variable_get(:@username).should eq("User")
#     end

#     it "sets username" do
#       data_collector_streamer.instance_variable_get(:@password).should eq("Password")
#     end

#     it "sets username" do
#       data_collector_streamer.instance_variable_get(:@url).should eq("https://example.com/stream.json")
#     end
#   end

#   context "#stream" do
#     it "raises exception when no block is passed" do
#       lambda{
#         data_collector_streamer.stream
#       }.should raise_error("No block provided for call to Gnip::PowertrackStreamer#stream")
#     end
#   end

# end
