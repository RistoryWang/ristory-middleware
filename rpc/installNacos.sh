#!/bin/bash
#author: ristory
#description: init nacos
wget https://github.com/alibaba/nacos/releases/download/1.0.1/nacos-server-1.0.1.tar.gz
tar -zxvf nacos-server-1.0.1.tar.gz
mv nacos /usr/local/
#create database nacos character set UTF8;
#grant all on nacos.* to nacos@"%" identified by "yourpasswd";
#grant all on nacos.* to nacos@"localhost" identified by "yourpasswd";
#FLUSH PRIVILEGES;
sed -i 's/server.port=8848/server.port=9090/g' /usr/local/nacos/conf/application.properties
sed -i '$a ## mysql datasource' /usr/local/nacos/conf/application.properties
sed -i '$a spring.datasource.platform=mysql' /usr/local/nacos/conf/application.properties
sed -i '$a db.num=1' /usr/local/nacos/conf/application.properties
sed -i '$a db.url.0=jdbc:mysql://127.0.0.1:3306/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true
' /usr/local/nacos/conf/application.properties
sed -i '$a db.user=nacos' /usr/local/nacos/conf/application.properties
sed -i '$a db.password=yourpasswd' /usr/local/nacos/conf/application.properties
#import nacos_mysql.sql
cd /usr/local/nacos/bin
sh startup.sh -m standalone &





