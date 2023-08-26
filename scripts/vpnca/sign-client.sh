#!/bin/bash

# sign one client signing request and generate the certificate

if [ $# -ne 1 ]; then
echo "No client profile name is given"
exit
fi

sudo chown vpnca.vpnca /tmp/${1}.req

cd ~/easy-rsa
./easyrsa import-req /tmp/${1}.req ${1}
./easyrsa sign-req client ${1}
cp ~/easy-rsa/pki/issued/${1}.crt /tmp

