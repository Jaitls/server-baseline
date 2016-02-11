#!/bin/bash
#master node installation script

#download & uncompress JDK 1.7.0_80
cd; wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
tar xvzf jdk-7u80-linux-x64.tar.gz
mkdir -p /usr/java/
cp -r jdk1.7.0_80/ /usr/java/
rm -r jdk1.7.0_80/
rm jdk-7u80-linux-x64.tar.gz

#set JAVA environment variables & add to PATH
sh -c 'echo "export JAVA_HOME=/usr/java/jdk1.7.0_80" >> /etc/profile.d/java.sh'
sh -c 'echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile.d/java.sh'
sh -c 'echo "export JAVA_HOME=/usr/java/jdk1.7.0_80" >> /etc/default/bigtop-utils'
chmod a+x /etc/profile.d/java.sh
