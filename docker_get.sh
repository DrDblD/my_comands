#! /bin/bash

while [[ `ps aux | grep -i apt | wc -l` != 1 ]] ; do
    echo 'apt is locked by another process.'
    sleep 15
    ps aux | grep -i apt | wc -l
done

apt update
apt install ca-certificates curl gnupg lsb-release

KEY=docker-archive-keyring.gpg
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/$KEY

ARCH=`dpkg --print-architecture`
LINK=https://download.docker.com/linux/debian
RELEASE=`lsb_release -cs`
echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/$KEY] $LINK $RELEASE stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io
groupadd docker
usermod -aG docker ${USER}