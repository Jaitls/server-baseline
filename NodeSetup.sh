#!/bin/bash
#customize slave nodes


#create user jaitls
useradd -m -s /bin/bash -p '$1$rB9ODpBI$VrNTbQfuPOb2fAxcEBLAK0' jaitls
gpasswd -a jaitls sudo

#copy authorized public key
su jaitls -c "mkdir ~/.ssh; chmod 700 ~/.ssh"
cat ~/.ssh/authorized_keys >> /home/jaitls/.ssh/authorized_keys

#disable root login and ssh password authentiation
sed -i.bak -e 's/PermitRootLogin\syes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i''      -e 's/#PasswordAuthentication\syes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo service ssh restart

#download dotfiles
su jaitls -c "cd; curl -#L https://github.com/Jaitls/mybash/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,LICENSE-MIT.txt}"