#!/bin/bash
#author: ristory
#description: init development environment
yum update -y
yum install -y lrzsz wget curl unzip net-tools gcc.x86_64 gcc-c++
#jdk env(jdk8+jce8)
mkdir -p /root/java
cd /root/java
wget ftp://yourftp.com/jdk-8u102-linux-x64.rpm
rpm -ivh jdk-8u102-linux-x64.rpm
rm jdk-8u102-linux-x64.rpm
sed -i '$a #set java environment' /etc/profile
sed -i '$a export JAVA_HOME=/usr/java/latest' /etc/profile
sed -i '$a export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' /etc/profile
sed -i '$a export PATH=$PATH:$JAVA_HOME/bin' /etc/profile
source /etc/profile
cd /usr/bin
ln -s -f /usr/java/latest/bin/java
java -version
echo "========================================="
echo "===               JDK8 ok             ==="
echo "========================================="
cd /root/java
wget ftp://yourftp.com/jce_policy-8.zip
unzip jce_policy-8.zip
cd /usr/java/latest/jre/lib/security
mv local_policy.jar local_policy.jar.bak
mv US_export_policy.jar US_export_policy.jar.bak
cp /root/java/UnlimitedJCEPolicyJDK8/local_policy.jar /usr/java/latest/jre/lib/security
cp /root/java/UnlimitedJCEPolicyJDK8/US_export_policy.jar /usr/java/latest/jre/lib/security
rm -rf /root/java/UnlimitedJCEPolicyJDK8
rm -rf jce_policy-8.zip
echo "========================================="
echo "===               JCE8 ok             ==="
echo "========================================="
systemctl stop firewalld.service
echo "========================================="
echo "===           Stop firewall ok        ==="
echo "========================================="
echo "========================================="
echo "===    100% Done. Pls reconnect ssh   ==="
echo "========================================="
exit