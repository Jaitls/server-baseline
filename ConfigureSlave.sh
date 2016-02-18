#!/bin/bash
#slave node configuration

#set slave ip address to ip of eth0
slaveip="$( ip route get 8.8.8.8 | awk 'NR==1 {print $NF}' )"

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi

#check validity of ip address
if [[ $slaveip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "adding $HOSTNAME with ip address $slaveip to conf files"
else
  echo "invalid ip address"
  exit 1
fi

#allow mesos slaves to communicate to mesos master via zk protocol
sed -i -e 's/localhost/162.243.120.52/g' /etc/mesos/zk
#stop zookeeper on slave machines
service zookeeper stop
sh -c "echo manual | tee /etc/init/zookeeper.override"

#stop mesos-master process on slave machines
service mesos-master stop
sh -c "echo manual | tee /etc/init/mesos-master.override"

#set mesos slave ip address and hostname
sh -c "echo $slaveip | tee /etc/mesos-slave/ip"
cp /etc/mesos-slave/ip /etc/mesos-slave/hostname

#restart mesos slave
service mesos-slave restart