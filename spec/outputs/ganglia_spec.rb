# encoding: utf-8
require_relative "../spec_helper"

describe LogStash::Outputs::Ganglia do

  it "should register without errors" do
    plugin = LogStash::Plugin.lookup("output", "ganglia").new("value" => "0", "metric" => "my.metric")
    expect { plugin.register }.to_not raise_error
  end

  describe "#send" do

    let(:value)  { 12345 }
    let(:metric) { "metric.mine" }
    subject { LogStash::Outputs::Ganglia.new("value" => "%{value}", "metric" => "%{metric}") }

    let(:properties) { { "message" => "This is a message!", "value" => value, "metric" => metric}}
    let(:event)      { LogStash::Event.new(properties) }


    let(:host) { subject.host }
    let(:port) { subject.port }
    before(:each) do
      subject.register
    end

    it "should send the message to ganglia" do
      expect(Ganglia::GMetric).to receive(:send).with(host, port, hash_including(:name => metric, :value => value))
      subject.receive(event)
    end
  end
end
