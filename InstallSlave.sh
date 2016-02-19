#!/bin/bash
#master node installation script

#future read-in following parameters from json
	#master or slave config option
	#master slave ip addresses
	#
	#

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi
#install JDK 1.7.0_80 for Hadoop
cd; wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
tar xvzf jdk-7u80-linux-x64.tar.gz
mkdir -p /usr/java/
cp -r jdk1.7.0_80/ /usr/java/
rm -r jdk1.7.0_80/
rm jdk-7u80-linux-x64.tar.gz
#set JAVA environment variables
# sh -c 'echo "export JAVA_HOME=/usr/java/jdk1.7.0_80" >> /etc/profile.d/java.sh'
# sh -c 'echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile.d/java.sh'
sh -c 'echo "export JAVA_HOME=/usr/java/jdk1.7.0_80" >> /etc/default/bigtop-utils'
#chmod a+x /etc/profile.d/java.sh

#install Java 8
add-apt-repository ppa:webupd8team/java
apt-get -y update
apt-get install -y oracle-java8-installer oracle-java8-set-default

#install mesos
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list
apt-get -y update

#this will install zookeeper, mesos, marathon, and chronos (for all masters)
#apt-get -y install mesosphere
#this will install mesos and zookeeper (for all slaves)
apt-get -y install mesos
#install docker on all slaves
apt-get -y install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ${DISTRO}-${CODENAME} main" | tee /etc/apt/sources.list.d/docker.list
apt-get -y update
apt-get purge lxc-docker
apt-get -y install apparmor
apt-get -y install linux-image-extra-$(uname -r)
apt-get -y install docker-engine
