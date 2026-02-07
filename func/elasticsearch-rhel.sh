#!/bin/bash
InstallElasticsearchRH() {
    dnf update -y
dnf install wget epel-release -y
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
echo "[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md"| tee /etc/yum.repos.d/elasticsearch-7.x.repo
dnf install -y elasticsearch
/usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-attachment -y
sysctl -w vm.max_map_count=262144

echo "# /etc/elasticsearch/elasticsearch.yml

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
indices.query.bool.max_clause_count: 2000" | tee -a /etc/elasticsearch/elasticsearch.yml
firewall-cmd --permanent --add-port=9200/tcp
firewall-cmd --reload
systemctl enable --now elasticsearch
}