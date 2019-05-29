#!/bin/bash
#author: ristory
###########install redis###########install redis###########install redis###########install redis###########install redis###########
cd /root
wget http://download.redis.io/releases/redis-3.2.8.tar.gz
tar zxvf redis-3.2.8.tar.gz
rm -rf redis-3.2.8.tar.gz
mv redis-3.2.8 /usr/local
cd /usr/local/redis-3.2.8
make
sed -i '/bind 127.0.0.1/s/bind 127.0.0.1/bind 0.0.0.0/' /usr/local/redis-3.2.8/redis.conf
sed -i '/daemonize no/s/no/yes/' /usr/local/redis-3.2.8/redis.conf
sed -i '/# requirepass foobared/s/# requirepass foobared/requirepass n9rfidnhGa3feePUoqcL/' /usr/local/redis-3.2.8/redis.conf
#启动redis
/usr/local/redis-3.2.8/src/redis-server /usr/local/redis-3.2.8/redis.conf
###########install mongo###########install mongo###########install mongo###########install mongo###########install mongo###########
cd /root
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.1.tgz
tar -zxvf mongodb-linux-x86_64-rhel70-3.4.1.tgz
cd /usr/local/
mkdir -p mongodb
cd /usr/local/mongodb
mv /root/mongodb-linux-x86_64-rhel70-3.4.1/* /usr/local/mongodb
rm -rf /root/mongo*
mkdir -p data
mkdir -p logs
sudo tee bin/mongodb.conf <<-'EOF'
dbpath = /usr/local/mongodb/data
logpath = /usr/local/mongodb/logs/mongodb.log
bind_ip = 0.0.0.0   
port = 27017 
fork = true 
nohttpinterface = true
EOF
#启动mongodb程序（使用配置文件mongodb.conf定义的参数启动）：
/usr/local/mongodb/bin/mongod --config /usr/local/mongodb/bin/mongodb.conf
#新建数据库和用户密码
cd /usr/local/mongodb/bin
./mongo <<EOF
use ristory;
db.usr.insert({'name':'ristory'});
db.createUser( 
 { 
     user: "ristory", 
     pwd: "n9rfidnhGa3feePUoqcL", 
     roles: 
     [ 
       { 
         role: "readWrite", 
         db: "ristory" 
       } 
     ] 
   } 
 )  ;
exit
EOF
#配置开机自启动mongodb
#vi /etc/rc.d/rc.local 
#在文件中加入：
#/usr/local/mongodb/bin/mongod --config /usr/local/mongodb/bin/mongodb.conf 
###########install postgresql###########install postgresql###########install postgresql###########install postgresql###########
cd /root
sed -i '/\[base\]/a\exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo
sed -i '/\[updates\]/a\exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo
#http://yum.postgresql.org/repopackages.php
yum -y localinstall https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
#yum list postgres*
yum -y install postgresql96-server
#initdb
su - postgres -c /usr/pgsql-9.6/bin/initdb
#/usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data -l logfile start
#修改配置文件
cd /var/lib/pgsql/9.6/data
sed -i '/#listen_addresses/s/#listen_addresses/listen_addresses/' /var/lib/pgsql/9.6/data/postgresql.conf
sed -i '/listen_addresses/s/localhost/*/' /var/lib/pgsql/9.6/data/postgresql.conf
sed -i '/#port = 5432/s/#port = 5432/port = 1921/' /var/lib/pgsql/9.6/data/postgresql.conf
#修改访问控制文件
sed -i '/# IPv4 local connections:/a\host    all    all    0.0.0.0/0    md5' /var/lib/pgsql/9.6/data/pg_hba.conf
#systemctl enable|disable|start|stop|restart postgresql-9.6
systemctl restart postgresql-9.6
#创建数据库
su -l postgres -c "psql -U postgres -w -p 1921  -c \"create database lss_log;\""
#修改postgres密码
su -l postgres -c "psql -U postgres -w -p 1921  -c \"ALTER USER postgres WITH PASSWORD 'n9rfidnhGa3feePUoqcL';\""
###########install mysql###########install mysql###########install mysql###########install mysql###########install mysql###########
cd /root
wget http://repo.mysql.com/mysql-community-release-el7-7.noarch.rpm
rpm -ivh mysql-community-release-el7-7.noarch.rpm
rm -rf mysql-community-release-el7-7.noarch.rpm
yum -y install mysql-server
sed -i '/sql_mode/a\collation-server=utf8_general_ci' /etc/my.cnf
sed -i '/sql_mode/a\character_set_server=utf8' /etc/my.cnf
sed -i '/sql_mode/a\lower_case_table_names=1' /etc/my.cnf
systemctl disable mysqld
systemctl restart mysqld
mysql -uroot <<EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('n9rfidnhGa3feePUoqcL');
create database ristory character set UTF8;
grant all on ristory.* to ristory@"%" identified by "n9rfidnhGa3feePUoqcL";
grant all on ristory.* to ristory@"localhost" identified by "n9rfidnhGa3feePUoqcL";
FLUSH PRIVILEGES;
exit
EOF
systemctl status mysqld