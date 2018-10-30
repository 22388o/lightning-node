#!/bin/bash

source ${pwd/}init.sh #TODO: fix this so the dir is set as a var

ARG=$1

function start() {
    #waitforblock
    docker run --rm --name ${LNDNAME} --network container:${BTCNAME} \
        -v ${MNTVOL}/${BTCNAME}:/home/$RUNAS/.bitcoin \
        -v ${MNTVOL}/${LNDNAME}:/home/$RUNAS/.lnd \
        ${LNDIMAGE}
}

function stop() {
    docker stop ${LNDNAME}
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
