#!/bin/sh

cd lnd_src && LND_VERSION=$(git describe --abbrev=0 --tags)

cd ../
docker build -t jr0sco/lnd .
docker build -t jr0sco/lnd:lnd-${LND_VERSION} .

docker push jr0sco/lnd 
docker push jr0sco/lnd:lnd-${LND_VERSION}