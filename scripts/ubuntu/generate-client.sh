#!/bin/bash

# generate one client certificate signing request

if [ $# -ne 1 ]; then
echo "No client profile name is given"
exit
fi

cd ~/easy-rsa
./easyrsa gen-req ${1} nopass
cp pki/private/${1}.key ~/client-configs/keys/
cp pki/reqs/${1}.req /tmp
