#!/bin/sh
# Initial setup of your Ubuntu 18.04 machine, as root

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install screen
apt-get dist-upgrade -y

# docker
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# xorg
# I don't know if you can run X just within docker, without it
# on the host.
apt-get install -y xfce4 xfce4-goodies xfonts-base
# This might be a security weakness :\
perl -i -pe 's/allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config

apt-get autoclean && apt-get autoremove -y

# Create a user with the same SSH keys authorized as root but no password
useradd -ms /bin/bash ubuntu
mkdir ~ubuntu/.ssh/ ; cp ~/.ssh/authorized_keys ~ubuntu/.ssh/ ; chown -R ubunt ~ubuntu/.ssh/
groupadd docker
usermod -aG docker ubuntu
