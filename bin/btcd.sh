#!/bin/bash

cd /$USER/lightning-node-master/bin
source $(pwd)/init.sh 

ARG=$1

function start() {
    docker run --rm --name ${BTCNAME} -d \
        -v ${BTCVOL}:/data \
        -p 8333:8333 \
        -p 127.0.0.1:8332:8332 \
        -p 9735:9735 \
        -p 18332:18332 \
        -p 18333:18333 \
        ${BTCIMAGE}
}

function stop() {
    # docker exec-it  bitcoind_mainnet bitcoin-cli stop
    docker stop ${BTCNAME}
}

function restart() {
    stop; sleep 5; start
}

function status() {
    docker ps -f name=${BTCNAME}
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