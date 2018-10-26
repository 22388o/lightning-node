#!/bin/bash

source $(pwd)/init.sh 

ARG=$1

function start() {
    waitforblock
    docker run --rm --name lightning --network container:bitcoind_mainnet \
        -v /scratch/bitcoin/mainnet/bitcoind:/root/.bitcoin -v \
        /scratch/bitcoin/mainnet/clightning:/root/.lightning \
        --entrypoint /usr/bin/lightningd ${LNDIMAGE} --network=bitcoin --log-level=debug
}

function stop() {
    docker run --network container:lightning ${LNDIMAGE} lightning-cli stop
}

function restart() {
    stop; sleep 5; start
}

function status() {
    docker ps -f name=lightning
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