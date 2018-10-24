#!/bin/bash

# https://medium.com/@dougvk/run-your-own-mainnet-lightning-node-2d2eab628a8b
# userdata found in /var/lib/cloud/instances/XXXXXXXXX/user-data.txt

# install required packages
apt-get update
apt-get -y install docker.io python3 jq vim unzip git

# setup s3cmd
# wget https://github.com/s3tools/s3cmd/archive/master.zip
# unzip master.zip
# cd s3cmd-master
# python3 setup.py install

# get lightning stack files
git clone https://github.com/jrosco/lightning-node.git
cd lightning-node

# setup lightning app
# git clone https://github.com/dougvk/lightning-node.git
# cd lightning-node/
# docker build . -t lnd1/bitcoind

# get a list of lnd peers
# lnd-cli listnodes| grep 'nodeid\|\"address\":\|port' | awk {'print $2'} | cut -d\" -f 2