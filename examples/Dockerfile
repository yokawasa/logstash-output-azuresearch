FROM docker.elastic.co/logstash/logstash-oss:6.2.4

ARG AZURE_ACCOUNT
ENV AZURE_ACCOUNT=${AZURE_ACCOUNT}
ARG AZURE_APIKEY
ENV AZURE_APIKEY=${AZURE_APIKEY}

EXPOSE 514

COPY logstash.conf /etc/logstash.conf
RUN logstash-plugin install mrcooper-logstash-output-azuresearch
CMD [‘-f’, ‘/etc/logstash.conf’]
