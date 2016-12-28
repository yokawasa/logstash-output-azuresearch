# Azure Search output plugin for Logstash

logstash-output-azuresearch is a logstash plugin to output to Azure Search. [Logstash](https://www.elastic.co/products/logstash) is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite [destinations](https://www.elastic.co/products/logstash). [Azure Search](https://docs.microsoft.com/en-us/azure/search/search-what-is-azure-search) is a managed cloud search service provided in Microsoft Azure.

## Installation

You can install this plugin using the Logstash "plugin" or "logstash-plugin" (for newer versions of Logstash) command:
```
bin/plugin install logstash-output-azuresearch
# or
bin/logstash-plugin install logstash-output-azuresearch  (Newer versions of Logstash)
```
Please see [Logstash reference](https://www.elastic.co/guide/en/logstash/current/offline-plugins.html) for more information.

## Configuration

```
output {
    azuresearch {
        endpoint => "https://<YOUR ACCOUNT>.search.windows.net"
        api_key => "<AZURESEARCH API KEY>"
        search_index => "<SEARCH INDEX NAME>"
        column_names => ['col1','col2','col3'..]  ##  ## list of column names (array)
        key_names => ['key1','key2','key3'..] ## list of Key names (array)
        flush_items => <FLUSH_ITEMS_NUM>
        flush_interval_time => <FLUSH INTERVAL TIME(sec)>
   }
}
```

 * **endpoint (required)** - Azure Search service endpoint URI
 * **api\_key (required)** - Azure Search API key
 * **search\_index (required)** - Azure Search Index name to insert records
 * **column\_names (required)** - List of column names (array) in a target Azure search index. 1st item in column_names should be primary key
 * **key\_names (optional)** - Default:[] (empty array). List of key names (array) in in-coming record to insert. The number of keys in key_names must be equal to the one of columns in column_names. Also the order or each item in key_names must match the one of each items in column_names.
 * **flush_items (optional)** - Default 50. Max number of items to buffer before flushing (1 - 1000).
 * **flush_interval_time (optional)** - Default 5. Max number of seconds to wait between flushes.

## Tests

Here is an example configuration where Logstash's event source and destination are configured as standard input and Azure Search respectively.

### Example Configuration
```
input {
    stdin {
        codec => json_lines
    }
}

output {
    azuresearch {
        endpoint => "https://<YOUR ACCOUNT>.search.windows.net"
        api_key => "<AZURESEARCH API KEY>"
        search_index => "<SEARCH INDEX NAME>"
        column_names => ['id','user_name','message','created_at']
        key_names => ['postid','user','content','posttime']
        flush_items => 100
        flush_interval_time => 5
    }
}
```
You can find example configuration files in logstash-output-azuresearch/examples.

### Run the plugin with the example configuration

Now you run logstash with the the example configuration like this:
```
# Test your logstash configuration before actually running the logstash
bin/logstash -f logstash-stdin-json-to-azuresearch.conf --configtest
# run
bin/logstash -f logstash-stdin-json-to-azuresearch.conf
```

Here is an expected output for sample input (JSON Lines):

<u>JSON Lines</u>
```
{ "id": "a001", "user_name": "user001", "message":"msg001", "created_at":"2016-12-28T00:01:00Z" },
{ "id": "a002", "user_name": "user002", "message":"msg002", "created_at":"2016-12-28T00:02:00Z" },
{ "id": "a003", "user_name": "user003", "message":"msg003", "created_at":"2016-12-28T00:03:00Z" },
```
<u>Output (Azure Search POST message)</u>
```
"value": [
    { "@search.score": 1, "id": "a001", "user_name": "user001", "message": "msg001", "created_at": "2016-12-28T00:01:00Z" },
    { "@search.score": 1, "id": "a002", "user_name": "user002", "message": "msg002", "created_at": "2016-12-28T00:02:00Z" },
    { "@search.score": 1, "id": "a003", "user_name": "user003", "message": "msg003", "created_at": "2016-12-28T00:03:00Z" }
]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yokawasa/logstash-output-azuresearch.
