# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "stud/buffer"

class LogStash::Outputs::Azuresearch < LogStash::Outputs::Base
  include Stud::Buffer

  config_name "azuresearch"

  # Azure Search Endpoint URL
  config :endpoint, :validate => :string, :required => true

  # zure Search API key
  config :api_key, :validate => :string, :required => true

  # Azure Search Index name to insert records
  config :search_index, :validate => :string, :required => true

  # Column names in a target Azure search index.
  # 1st item in column_names should be primary key
  config :column_names, :validate => :array, :required => true

  # Key names in incomming record to insert.
  # The number of keys in key_names must be equal to the one of columns in column_names.
  # Also the order or each item in key_names must match the one of each items in column_names.
  config :key_names, :validate => :array, :default => []

  # Max number of items to buffer before flushing (1 - 1000). Default 50.
  config :flush_items, :validate => :number, :default => 50
  
  # Max number of seconds to wait between flushes. Default 5
  config :flush_interval_time, :validate => :number, :default => 5


  public
  def register
    require_relative 'azuresearch/client'

    ## Configure
    if @key_names.length < 1
      @key_names = @column_names
    end
    raise ArgumentError, 'NOT match keys number: column_names and key_names' \
          if @key_names.length != @column_names.length

    @primary_key_in_event = @key_names[0]
    ## Initialize Azure Search client Instance
    @client=AzureSearch::Client::new( @endpoint, @api_key )

    buffer_initialize(
        :max_items => @flush_items,
        :max_interval => @flush_interval_time,
        :logger => @logger
      )

  end # def register

  public
  def receive(event)
    # Simply save an event for later delivery
    buffer_receive(event)
  end # def event 

  # called from Stud::Buffer#buffer_flush when there are events to flush
  public
  def flush (events, close=false)

    documents = []  #this is the array of hashes to add Azure search
    events.each do |event|
      document = {}
      event_hash = event.to_hash()

      ## Check if event contains primary item that should be stored as 
      ## primary key in Azure Search
      if not event_hash.include?(@primary_key_in_event)
        $logger.warn( "The event does not contain primary item!!: " + (event_hash.to_json).to_s)
        next
      end

      @column_names.each_with_index do|k, i|
        ikey = @key_names[i]
        ival = event_hash.include?(ikey) ? event_hash[ikey] : ''
        document[k] = ival
      end
      documents.push(document)
    end

    ## Skip in case there are no candidate documents to deliver
    if documents.length < 1
      return
    end

    begin
      @client.add_documents(@search_index, documents)
    rescue RestClient::ExceptionWithResponse => rcex
      exdict = JSON.parse(rcex.response)
      $logger.error("RestClient Error: '#{rcex.response}', data=>" + (documents.to_json).to_s)
    rescue => ex
      $logger.error( "Error: '#{ex}'" + ", data=>" + (documents.to_json).to_s)
    end

  end # def flush

end # class LogStash::Outputs::AzureSearch
