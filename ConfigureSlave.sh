#!/bin/bash
#slave node configuration

slaveip=$1

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi

#check validity of ip address
if [[ $slaveip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "adding slace ip address:$slaveip to conf files"
else
  echo "enter valid slave ip address"
  exit 1
fi

#stop zookeeper on slave machines
service zookeeper stop
sh -c "echo manual | tee /etc/init/zookeeper.override"

#stop mesos-master process on slave machines
service mesos-master stop
sh -c "echo manual | tee /etc/init/mesos-master.override"

#set mesos slave ip address and hostename
sh -c "echo $slaveip | tee /etc/mesos-slave/ip"
cp /etc/mesos-slave/ip /etc/mesos-slave/hostename

#restart mesos slave
service mesos-slave restart