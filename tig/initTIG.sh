#!/bin/bash
#author: ristory
#install tig
wget https://dl.grafana.com/oss/release/grafana-6.2.1-1.x86_64.rpm 
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.6.x86_64.rpm
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.10.4-1.x86_64.rpm
yum -y localinstall grafana-6.2.1-1.x86_64.rpm
yum -y localinstall influxdb-1.7.6.x86_64.rpm
yum -y localinstall telegraf-1.10.4-1.x86_64.rpm
#remove rpm resources
rm -rf *.rpm
#modify grafana setting
rm -rf /etc/grafana/grafana.ini
wget https://raw.githubusercontent.com/RistoryWang/ristory-config/master/grafana/grafana.ini
#start grafana
systemctl start grafana-server
#grafana plugins
grafana-cli plugins install grafana-clock-panel
grafana-cli plugins install grafana-piechart-panel

#modify influxdb setting
rm -rf /etc/influxdb/influxdb.conf
wget https://raw.githubusercontent.com/RistoryWang/ristory-config/master/influxdb/influxdb.conf
systemctl start influxdb
influx  -host '172.16.10.100' -port '9050' -username 'admin' -password 'ristorypassword' <<EOF
CREATE USER admin WITH PASSWORD 'ristorypassword' WITH ALL PRIVILEGES;
CREATE DATABASE telegraf;
CREATE USER telegraf WITH PASSWORD 'ristorypassword';
GRANT ALL PRIVILEGES TO telegraf;
EOF
#start grafana
systemctl start influxdb
#modify telegraf setting
rm -rf /etc/telegraf/telegraf.conf
wget https://raw.githubusercontent.com/RistoryWang/ristory-config/master/telegraf/telegraf.conf
#start telegraf
systemctl start influxdb

