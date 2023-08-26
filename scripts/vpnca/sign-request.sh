#!/bin/bash

# 1) sign the server signing request and generate the certificate
# 2) sign one client signing request and generate the certificate

if [ $# -ne 1 ]; then
echo "No client profile name is given"
exit
fi

sudo chown vpnca.vpnca /tmp/*.req

cd ~/easy-rsa
./easyrsa import-req /tmp/server.req server
./easyrsa sign-req server server

./easyrsa import-req /tmp/${1}.req ${1}
./easyrsa sign-req client ${1}

cp pki/issued/server.crt /tmp
cp pki/ca.crt /tmp

cp pki/issued/${1}.crt /tmp
