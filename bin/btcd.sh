#!/bin/bash

source ${pwd/}init.sh #TODO: fix this so the dir is set as a var

ARG=$1

function start() {
    docker run --rm --name ${BTCNAME} -d \
        -v ${MNTVOL}/${BTCNAME}:/home/$RUNAS/.bitcoin \
        -p 0.0.0.0:9735:9735 \
        -p 127.0.0.1:28332:28332 \
        -p 127.0.0.1:28333:28333 \
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
