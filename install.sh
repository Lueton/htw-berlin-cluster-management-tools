#!/bin/bash

# check if user has sudo permissions
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo"
    exit 1
fi

# check if host is connected to the internet

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 1 ]; then
    echo "Please make sure you are connected to the internet"
    exit 1
fi


# disable interactive mode
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# update packages
apt-get -y update
apt-get -y upgrade

# resize disk space
lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

# install required packages for ansible (especially python3) and add-apt-repository command
apt-get install software-properties-common -y

# add ansible repository and install ansible
add-apt-repository --yes --update ppa:ansible/ansible
apt-get -y install ansible

(cd playbook && ansible-playbook -i inventories/development/hosts.yaml site.yaml)
