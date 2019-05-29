#!/bin/bash
#author: ristory
#description: sentry

wget https://github.com/getsentry/onpremise/archive/master.zip
unzip master.zip
mv onpremise-master onpremise
#docker镜像源修改
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://k7p1t6fk.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker


yum install -y libffi-devel python-devel openssl-devel
#pip install gevent
# git clone https://github.com/getsentry/onpremise.git
cd onpremise
mkdir -p data/{sentry,postgres}
sed -i "s/# mail.backend: 'smtp'/mail.backend: 'smtp'/g" config.yml
sed -i "s/# mail.host: 'localhost'/mail.host: 'smtp.mxhichina.com'/g" config.yml
sed -i "s/# mail.port: 25/mail.port: 587/g" config.yml
sed -i "s/# mail.username: ''/mail.username: 'me@ristory.com'/g" config.yml 
sed -i "s/# mail.password: ''/mail.password: 'password'/g" config.yml
sed -i "s/# mail.use-tls: false/mail.use-tls: true/g" config.yml
sed -i "s/# mail.from: 'root@localhost'/mail.from: 'me@ristory.com'/g" config.yml
sed -i "s/'9000:9000'/'9070:9000'/g" docker-compose.yml
# sed -i '$a sentry-dingding~=0.0.1' requirements.txt
sed -i '$a redis-py-cluster==1.3.4' requirements.txt
sed -i '$a RUN pip install git+https://github.com/RistoryWang/sentry-dingding.git' Dockerfile



docker-compose build
docker-compose run --rm web config generate-secret-key
#vi docker-compose.yml
SKEY=`docker-compose run --rm web config generate-secret-key`
echo $SKEY
#手动替换
#sed -i "s/SENTRY_SECRET_KEY: ''/SENTRY_SECRET_KEY: "$SKEY"/g" docker-compose.yml

#docker-compose run --rm web upgrade
docker-compose run  -e SENTRY_SECRET_KEY=$SKEY --rm web upgrade --noinput
docker-compose run  -e SENTRY_SECRET_KEY=$SKEY --rm web createuser --email me@ristory.com --password ristorypassword --superuser
docker-compose up -d

docker-compose down
docker-compose build
make build
docker-compose up -d
