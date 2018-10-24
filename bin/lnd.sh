#!/bin/bash

source $(pwd)/init.sh 

ARG=$1

function start() {
    waitforblock
    docker run --rm --name ${LNDNAME} --network container:${BTCNAME} -d \
        -v /scratch/bitcoin/mainnet/bitcoind:/root/.bitcoin \
        -v /scratch/bitcoin/mainnet/clightning:/root/.lightning \
        ${LNDIMAGE} 
}

function stop() {
    docker exec ${LNDNAME} lightning-cli stop
}

function restart() {
    stop; sleep 5; start
}

function status() {
    docker ps -f name=${LNDNAME}
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