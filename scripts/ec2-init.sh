#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install easy-rsa -y
sudo apt-get install openvpn -y
sudo apt-get install net-tools -y

sudo su -c "useradd vpnca -s /bin/bash -m"
sudo chpasswd << 'END'
vpnca:trustme
END

sudo usermod -aG sudo vpnca
sudo mkdir -p /home/vpnca/.ssh
sudo chmod 700 /home/vpnca/.ssh
sudo cp /home/ubuntu/.ssh/authorized_keys /home/vpnca/.ssh/
sudo chown -R vpnca.vpnca /home/vpnca/.ssh
