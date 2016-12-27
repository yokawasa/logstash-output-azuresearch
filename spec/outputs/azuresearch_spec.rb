# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/azuresearch"
require "logstash/codecs/plain"
require "logstash/event"

describe LogStash::Outputs::Azuresearch do

  let(:endpoint) { 'https://<YOUR ACCOUNT>.search.windows.net' }
  let(:api_key) { '<AZURESEARCH API KEY>' }
  let(:search_index) { '<SEARCH INDEX NAME>' }
  let(:column_names) { ['id','user_name','message','created_at'] }
  let(:key_names) { ['postid','user','content','posttime'] }

  let(:azuresearch_config) {
    { 
      "endpoint" => endpoint, 
      "api_key" => api_key,
      "search_index" => search_index,
      "column_names" => column_names,
      "key_names" => key_names
    }
  }

  let(:azuresearch_output) { LogStash::Outputs::Azuresearch.new(azuresearch_config) }

  before do
     azuresearch_output.register
  end 

  describe "#flush" do
    it "Should successfully send the event to azuresearch" do
      events = []
      properties1 = { "postid" => "a0001", "user" => "foo", "content" => "msg0001", "posttime"=>"2016-12-27T00:01:00Z" }
      properties2 = { "postid" => "a0002", "user" => "bar", "content" => "msg0002", "posttime"=>"2016-12-27T00:02:00Z" }
      event1 =  LogStash::Event.new(properties1) 
      event2 =  LogStash::Event.new(properties2) 
      azuresearch_output.receive(event1)
      azuresearch_output.receive(event2)
      events.push(event1)
      events.push(event2)
      expect {azuresearch_output.flush(events)}.to_not raise_error
    end
  end

end
