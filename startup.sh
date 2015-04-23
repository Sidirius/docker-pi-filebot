#!/bin/bash
mkdir /var/run/sshd

apt-get update
apt-get upgrade -y --force-yes
apt-get dist-upgrade -y --force-yes

while [ 1 ]; do
    /bin/bash
done
