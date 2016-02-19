#!/bin/bash
#Configure Mesos DNS

#capture ip address of machine script is run on
serverip="$( ip route get 8.8.8.8 | awk 'NR==1 {print $NF}' )"

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi


#create config file for mesos-dns
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

#create marathon application specs for mesos-dns
cat <<EOF > ~/marathon-mesosdns.json
{
    "args": [
        "/mesos-dns",
        "-config=/config.json"
    ],
    "container": {
        "docker": {
            "image": "mesosphere/mesos-dns",
            "network": "HOST"
        },
        "type": "DOCKER",
        "volumes": [
            {
                "containerPath": "/config.json",
                "hostPath": "/etc/mesos-dns/config.js",
                "mode": "RO"
            }
        ]
    },
    "cpus": 0.2,
    "id": "mesos-dns",
    "instances": 1,
}
EOF

#Post app specs via Marathon API
su jaitls -c "curl -X POST -H "Content-Type: application/json" http://localhost:8080/v2/apps -d@~/marathon-mesosdns.json"