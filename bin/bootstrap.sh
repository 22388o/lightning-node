#!/bin/bash

# https://medium.com/@dougvk/run-your-own-mainnet-lightning-node-2d2eab628a8b
# userdata found in /var/lib/cloud/instances/XXXXXXXXX/user-data.txt

# install required packages
apt-get update
apt-get -y install docker.io python3 jq vim

# setup s3cmd
# wget https://github.com/s3tools/s3cmd/archive/master.zip
# unzip master.zip
# cd s3cmd-master
# python3 setup.py install

# setup lightning app
# git clone https://github.com/dougvk/lightning-node.git
# cd lightning-node/
# docker build . -t lnd1/bitcoind

# setup aliases
echo "alias btc-logs='docker logs bitcoind_mainnet --tail 10 -f'" >> ~/.bashrc
echo "alias lnd-logs='docker logs lightning --tail 10 -f'" >> ~/.bashrc
echo "alias btc-cli='docker run --rm --network container:bitcoind_mainnet -v /scratch/bitcoin/mainnet/bitcoind:/data lnd1/bitcoind:latest bitcoin-cli $@'" >> ~/.bashrc
echo "alias lnd-cli='docker run --rm --network container:lightning -v /scratch/bitcoin/mainnet/clightning:/data cdecker/lightningd:latest lightning-cli $@'" >> ~/.bashrc

# get a list of lnd peers
# lnd-cli listnodes| grep 'nodeid\|\"address\":\|port' | awk {'print $2'} | cut -d\" -f 2