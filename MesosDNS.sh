#!/bin/bash
#Configure Mesos DNS

#capture ip address of machine script is run on
serverip="$( ip route get 8.8.8.8 | awk 'NR==1 {print $NF}' )"

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi


mkdir /etc/mesos-dns
cat <<EOF > /etc/mesos-dns/config.json
{
  "zk": "zk://$serverip:2181/mesos",
  "refreshSeconds": 60,
  "ttl": 60,
  "domain": "mesos",
  "port": 53,
  "resolvers": ["169.254.169.254","10.0.0.1, 8.8.8.8"],
  "timeout": 5,
  "email": "root.mesos-dns.mesos"
}
EOF