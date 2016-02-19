#!/bin/bash
#install docker on all slaves
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
apt-get -y install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ${DISTRO}-${CODENAME} main" | tee /etc/apt/sources.list.d/docker.list
apt-get -y update
apt-get purge lxc-docker
apt-get -y install apparmor
apt-get -y install linux-image-extra-$(uname -r)
apt-get -y install docker-engine