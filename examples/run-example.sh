#!/bin/sh

LOGSTASH_HOME=/opt/logstash

cat data.json | $LOGSTASH_HOME/bin/logstash -f logstash-stdin-to-azuresearch.conf
