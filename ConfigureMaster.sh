#!/bin/bash
#master node configuration

##Zookeeper##
#add zk master ip addresses to zk config file
sed -i -e 's/localhost/162.243.120.52/g' /etc/mesos/zk
#add unique master id [1-255] for each zookeeper master
sh -c "echo '1' > /etc/zookeeper/conf/myid"
#sh -c "echo '$varxyz' > /etc/zookeeper/conf/myid"
#add zk master server info to conf file
sed -i -e 's/#server.1=zookeeper1:2888:3888/server.1=162.243.120.52:2888:3888/' /etc/zookeeper/conf/zoo.cfg


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

