# unfinished

## Redis init

### centos7下一键部署启动
#### single or master
##### curl -s https://raw.githubusercontent.com/RistoryWang/shell/master/initRedis.sh | bash -s 4.0.9 passwd master
#### slave
##### curl -s https://raw.githubusercontent.com/RistoryWang/shell/master/initRedis.sh | bash -s 4.0.9 passwd slave 192.168.10.221 6379

### 需要用到的包
#### yum install -y lrzsz wget curl unzip net-tools gcc.x86_64 gcc-c++


medis 0.6.1
node v4.8.2
npm 2.15.11
webpack@2.2.0 --save-dev

** must add '-loader' suffix