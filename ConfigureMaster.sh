#!/bin/bash
#master node configuration

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi

##Zookeeper##
#add zk master ip addresses to zk config file
#add each master in format "zk://192.0.2.1:2181,192.0.2.2:2181,192.0.2.3:2181/mesos"
sed -i -e 's/localhost/162.243.120.52/g' /etc/mesos/zk
#add unique master id [1-255] for each zookeeper master
sh -c "echo '1' > /etc/zookeeper/conf/myid"
#sh -c "echo '$varxyz' > /etc/zookeeper/conf/myid"
#add zk master server info to conf file
sed -i -e 's/#server.1=zookeeper1:2888:3888/server.1=162.243.120.52:2888:3888/' /etc/zookeeper/conf/zoo.cfg
#add "server.2=192.168.2.2:2888:3888" etc if needed

##Mesos##
#set mesos master quorum size for cluster
sh -c "echo '1' > /etc/mesos-master/quorum"
#assign ip address for mesos master
sh -c "echo '162.243.120.52' > /etc/mesos-master/ip"
cp /etc/mesos-master/ip /etc/mesos-master/hostname

##Marathon##
##configure marathon master ip to conf files
mkdir -p /etc/marathon/conf
cp /etc/mesos-master/hostname /etc/marathon/conf
cp /etc/mesos/zk /etc/marathon/conf/master
cp /etc/marathon/conf/master /etc/marathon/conf/zk
sed -i -e 's/mesos/marathon/g' /etc/marathon/conf/zk

#turn off slave services on master
service mesos-slave stop
sh -c "echo 'manual' > /etc/init/mesos-slave.override"

#restart all services
service zookeeper restart
service mesos-master restart
service marathon restart

