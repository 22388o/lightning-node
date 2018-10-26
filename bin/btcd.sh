#!/bin/bash

source $(pwd)/init.sh 

ARG=$1

function start() {
    docker run --rm --name bitcoind_mainnet -d \
    -v ${BTCVOL}:/data \
    -p 8333:8333 \
    -p 8332:8332 \
    -p 9735:9735 \
    -p 18332:18332 \
    -p 18333:18333 \
    ${BTCIMAGE}
}

function stop() {
    docker run --network container:bitcoind_mainnet lnd1/bitcoind:latest bitcoin-cli stop
    # docker stop bitcoind_mainnet
}

function restart() {
    stop; sleep 5; start
}

function status() {
    docker ps -f name=bitcoind_mainnet
}

case ${ARG} in
    start)   
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;           
    *)              
esac 