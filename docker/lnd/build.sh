#!/bin/sh

LND_VERSION="v0.7.1-beta"
LOOP_VERSION="v0.2.2-alpha"

docker build --build-arg LND_VERSION=${LND_VERSION} --build-arg LOOP_VERSION=${LOOP_VERSION} -t lnd .

docker tag jr0sco/lnd jr0sco/lnd:${LND_VERSION}
docker push jr0sco/lnd:${LND_VERSION}
