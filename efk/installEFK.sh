#!/bin/bash
#author: ristory
#install es&ik
version=7.1.0
ETH0=$(ifconfig eth0 | grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}')
#modify ES host
ES=$ETH0
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}-x86_64.rpm
rpm -ivh elasticsearch-${version}-x86_64.rpm
cd /etc/elasticsearch/
rm -rf /etc/elasticsearch/elasticsearch.yml
rm -rf /etc/elasticsearch/jvm.options
wget https://raw.githubusercontent.com/RistoryWang/ristory-config/master/elasticsearch/elasticsearch.yml
sed -i 's/0.0.0.0/'"$ETH0"'/g' elasticsearch.yml
wget https://raw.githubusercontent.com/RistoryWang/ristory-config/master/elasticsearch/jvm.options
cd /usr/share/elasticsearch/plugins
mkdir -p ik && cd ik
wget https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${version}/elasticsearch-analysis-ik-${version}.zip
unzip elasticsearch-analysis-ik-${version}.zip
cd ~
#install kibana
wget https://artifacts.elastic.co/downloads/kibana/kibana-${version}-x86_64.rpm
rpm -ivh kibana-${version}-x86_64.rpm
cd /etc/kibana/
rm -rf /etc/kibana/kibana.yml
wget https://raw.githubusercontent.com/RistoryWang/ristory-config/master/kibana/kibana.yml
sed -i 's/0.0.0.0/'"$ETH0"'/g' kibana.yml
cd ~
#install filebeat
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${version}-x86_64.rpm
rpm -ivh filebeat-${version}-x86_64.rpm
cd /etc/filebeat/
rm -rf /etc/filebeat/filebeat.yml
wget https://raw.githubusercontent.com/RistoryWang/ristory-config/master/filebeat/filebeat.yml
sed -i 's/0.0.0.0/'"$ES"'/g' filebeat.yml
cd ~