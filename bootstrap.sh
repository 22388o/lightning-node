#!/bin/bash

# https://medium.com/@dougvk/run-your-own-mainnet-lightning-node-2d2eab628a8b
# userdata found in /var/lib/cloud/instances/XXXXXXXXX/user-data.txt

apt-get update
apt-get -y install docker.io

git clone https://github.com/dougvk/lightning-node.git
cd lightning-node/

docker build . -t lnd1/bitcoind

mkdir -p /scratch/bitcoin/mainnet/bitcoind

docker run --name bitcoind_mainnet -d -v /scratch/bitcoin/mainnet/bitcoind:/data \
    -p 8333:8333 -p 9735:9735 lnd1/bitcoind:latest

mkdir -p /scratch/bitcoin/mainnet/clightning

docker run --rm --name lightning --network container:bitcoind_mainnet \
    -v /scratch/bitcoin/mainnet/bitcoind:/root/.bitcoin -v \
    /scratch/bitcoin/mainnet/clightning:/root/.lightning \
    --entrypoint /usr/bin/lightningd cdecker/lightningd:latest --network=bitcoin --log-level=debug

# setup aliases
alias btc-logs='docker logs bitcoind_mainnet --tail "10" -f' >> ~/.bashrc
alias btc-cli='docker run --rm --network container:bitcoind_mainnet -v /scratch/bitcoin/mainnet/bitcoind:/data lnd1/bitcoind:latest bitcoin-cli "$@"' >> ~/.bashrc