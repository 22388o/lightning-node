#!/bin/bash

source $(pwd)/init.sh #TODO: fix this so the dir is set as a var

ARG=$1

function start() {
    touch ${MNTVOL}/${ELECXNAME}/.env
    docker run --rm --name ${ELECXNAME} --network container:${BTCNAME} -d \
        --env-file ${MNTVOL}/${ELECXNAME}/.env \
        -v ${MNTVOL}/${BTCNAME}:/home/$RUNAS/.bitcoin \
        ${ELECXIMAGE}
}

function stop() {
    docker stop ${ELECXNAME}
}

function restart() {
    stop; sleep 5; start
}

function status() {
    docker ps -f name=${ELECXNAME}
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
