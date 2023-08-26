#!/bin/bash

# 1) setup easy-rsa and init pki
# 2) generate one client certificate signing request

if [ $# -ne 1 ]; then
echo "No client profile name is given"
exit
fi

mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
chmod 700 /home/vpnca/easy-rsa

cd ~/easy-rsa
openvpn --genkey secret ta.key
sudo cp ta.key /etc/openvpn/server

cat << EOF >> vars
set_var EASYRSA_ALGO		    "ec"
set_var EASYRSA_DIGEST		    "sha512"
EOF

./easyrsa init-pki

./easyrsa gen-req server nopass
sudo cp /home/ubuntu/easy-rsa/pki/private/server.key /etc/openvpn/server/
cp /home/ubuntu/easy-rsa/pki/reqs/server.req /tmp

mkdir -p ~/client-configs/keys
chmod -R 700 ~/client-configs

./easyrsa gen-req ${1} nopass
cp pki/private/${1}.key ~/client-configs/keys/
cp pki/reqs/${1}.req /tmp
