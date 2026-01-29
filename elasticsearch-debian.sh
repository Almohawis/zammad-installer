#!/bin/bash

# 1
apt install curl apt-transport-https gnupg

# 2 Elasticsearch
apt install apt-transport-https sudo wget curl gnupg
echo "deb [signed-by=/etc/apt/trusted.gpg.d/elasticsearch.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main"| \
  tee -a /etc/apt/sources.list.d/elastic-7.x.list > /dev/null
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
gpg --dearmor | tee /etc/apt/trusted.gpg.d/elasticsearch.gpg> /dev/null \
&& chmod 644 /etc/apt/trusted.gpg.d/elasticsearch.gpg
apt update
apt install elasticsearch -y
/usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-attachment
sysctl -w vm.max_map_count=262144

echo "
# /etc/elasticsearch/elasticsearch.yml

# Tickets above this size (articles + attachments + metadata)
# may fail to be properly indexed (Default: 100mb).
#
# When Zammad sends tickets to Elasticsearch for indexing,
# it bundles together all the data on each individual ticket
# and issues a single HTTP request for it.
# Payloads exceeding this threshold will be truncated.
#
# Performance may suffer if it is set too high.
http.max_content_length: 400mb

# Allows the engine to generate larger (more complex) search queries.
# Elasticsearch will raise an error or deprecation notice if this value is too low,
# but setting it too high can overload system resources (Default: 1024).
#
# Available in version 6.6+ only.
indices.query.bool.max_clause_count: 2000 " | tee -a /etc/elasticsearch/elasticsearch.yml
systemctl enable --now elasticsearch


