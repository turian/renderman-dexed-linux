#!/bin/sh
# Initial setup of your Ubuntu 18.04 machine, as root

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install screen
apt-get dist-upgrade -y

# docker
apt-get install -y docker.io

# xorg
# I don't know if you can run X just within docker, without it
# on the host.
apt-get install -y xinit
# This might be a security weakness :\
perl -i -pe 's/allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config

apt-get autoclean && apt-get autoremove -y

# Create a user with the same SSH keys authorized as root but no password
useradd -ms /bin/bash renderman
mkdir ~renderman/.ssh/ ; cp ~/.ssh/authorized_keys ~renderman/.ssh/ ; chown -R renderman ~renderman/.ssh/
groupadd docker
usermod -aG docker renderman
