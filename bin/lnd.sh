#!/bin/bash

source $(pwd)/init.sh #TODO: fix this so the dir is set as a var

ARG=$1

function start() {
    touch ${MNTVOL}/${LNDNAME}/.env
    docker run --rm --name ${LNDNAME} --network container:${BTCNAME} -d \
        --env-file ${MNTVOL}/${LNDNAME}/.env \
        -v ${MNTVOL}/${BTCNAME}:/data \
        -v ${MNTVOL}/${LNDNAME}:/data/.lnd \
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
