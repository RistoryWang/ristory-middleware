#!/bin/bash
#author: ristory
ver=$1
passwd=$2
type=$3
mip=$4
mport=$5
cd /root
wget http://download.redis.io/releases/redis-${ver}.tar.gz
tar zxvf redis-${ver}.tar.gz
rm -rf redis-${ver}.tar.gz
mv redis-${ver} /usr/local
cd /usr/local/redis-${ver}
make
export hostip=$(ifconfig eth0 | grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}')
sed -i '/bind 127.0.0.1/s/bind 127.0.0.1/bind '$hostip'/' /usr/local/redis-${ver}/redis.conf
sed -i '/daemonize no/s/no/yes/' /usr/local/redis-${ver}/redis.conf
sed -i '/# requirepass foobared/s/# requirepass foobared/requirepass '$passwd'/' /usr/local/redis-${ver}/redis.conf
if [[ "$type" == "slave" ]];then
	sed -i '$a slaveof '$mip' '$mport'' /usr/local/redis-${ver}/redis.conf
	sed -i '$a masterauth '$passwd'' /usr/local/redis-${ver}/redis.conf  
fi
cd /usr/lib/systemd/system
cat > redis.service <<EOF
[Unit]
Description=Redis
After=syslog.target network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
PIDFile=/var/run/redis_6379.pid
ExecStart= /usr/local/redis-${ver}/src/redis-server /usr/local/redis-${ver}/redis.conf
ExecReload=/bin/kill -s HUP $MAINPID 
ExecStop=/bin/kill -s QUIT $MAINPID 
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable redis
systemctl start redis