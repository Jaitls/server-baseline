#!/bin/bash
#customize slave nodes

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi

#create user jaitls
#MD5 password hash created using 'echo "password" | openssl passwd -1 -stdin'
useradd -m -s /bin/bash -p '$1$rB9ODpBI$VrNTbQfuPOb2fAxcEBLAK0' jaitls
gpasswd -a jaitls sudo

#copy authorized public key
su jaitls -c "mkdir ~/.ssh; chmod 700 ~/.ssh"
cat ~/.ssh/authorized_keys >> /home/jaitls/.ssh/authorized_keys
chmod 700 /home/jaitls/.ssh
chmod 600 /home/jaitls/.ssh/authorized_keys
chown jaitls:jaitls /home/jaitls/.ssh/authorized_keys

#disable root login and ssh password authentiation
dist=`grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}'`

if [ "$dist" == "Ubuntu" ]; then
	sed -i.bak -e 's/PermitRootLogin\syes/PermitRootLogin no/' /etc/ssh/sshd_config
	sed -i''      -e 's/#PasswordAuthentication\syes/PasswordAuthentication no/' /etc/ssh/sshd_config
	sudo service ssh restart
else
	sed -i.bak -e 's/#PermitRootLogin\syes/PermitRootLogin no/' /etc/ssh/sshd_config
	sed -i''      -e 's/PasswordAuthentication\syes/PasswordAuthentication no/' /etc/ssh/sshd_config
	sudo service sshd restart
fi


#download dotfiles
su jaitls -c "cd; curl -#L https://github.com/Jaitls/mybash/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,LICENSE-MIT.txt}"