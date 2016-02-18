#!/bin/bash
#slave node configuration

slaveip=$1

if [[ $slaveip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "adding $slaveip to conf files"
else
  echo "enter valid slave ip address"
fi

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi

#stop zookeeper on slave machines
service zookeeper stop
sh -c "echo manual | tee /etc/init/zookeeper.override"

#stop mesos-master process on slave machines
service mesos-master stop
sh -c "echo manual | tee /etc/init/mesos-master.override"