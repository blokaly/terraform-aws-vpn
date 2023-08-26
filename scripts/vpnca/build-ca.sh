#!/bin/bash

# 1) setup easy-rsa and init pki
# 2) build the CA

mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
chmod 700 /home/vpnca/easy-rsa

cd ~/easy-rsa

cat << EOF >> vars
set_var EASYRSA_REQ_COUNTRY     "HK"
set_var EASYRSA_REQ_PROVINCE	"HK"
set_var EASYRSA_REQ_CITY	    "HK"
set_var EASYRSA_REQ_ORG		    "Blokaly"
set_var EASYRSA_REQ_EMAIL	    "info@blokaly.com"
set_var EASYRSA_REQ_OU		    "AWS VPN"
set_var EASYRSA_ALGO		    "ec"
set_var EASYRSA_DIGEST		    "sha512"
EOF

./easyrsa init-pki

./easyrsa build-ca nopass
