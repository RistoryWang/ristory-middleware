#!/bin/bash
#author: ristory
#description: install and start ecs2oss sync
cd /root
mkdir -p ossimport && cd ossimport
wget http://gosspublic.alicdn.com/ossimport/standalone/ossimport-2.3.2.zip
unzip ossimport-2.3.2.zip
sed -i '/srcPrefix=/s/srcPrefix=d:\/work\/oss\/data\//srcPrefix=\/root\/data\/isz\//' /root/ossimport/conf/local_job.cfg
sed -i '/destAccessKey=/s/destAccessKey=/destAccessKey=yourkey/' /root/ossimport/conf/local_job.cfg
sed -i '/destSecretKey=/s/destSecretKey=/destSecretKey=yourpasswd/' /root/ossimport/conf/local_job.cfg
sed -i '/destDomain=/s/hangzhou-internal/hzfinance/' /root/ossimport/conf/local_job.cfg
sed -i '/destBucket=/s/destBucket=/destBucket=fh-ka/' /root/ossimport/conf/local_job.cfg
sed -i '/destPrefix=/s/destPrefix=/destPrefix=isz\//' /root/ossimport/conf/local_job.cfg
chmod a+x import.sh
bash import.sh