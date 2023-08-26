#!/bin/bash

# copy ta.key and all certificate files

sudo cp /tmp/*.crt ~/client-configs/keys/

cp ~/easy-rsa/ta.key ~/client-configs/keys/
sudo cp /etc/openvpn/server/ca.crt ~/client-configs/keys/
sudo chown ubuntu.ubuntu ~/client-configs/keys/*
