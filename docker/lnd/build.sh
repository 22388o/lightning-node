#!/bin/sh

LND_VERSION=$(grep LND_VERSION= Dockerfile | cut -d= -f2)
docker build -t jr0sco/lnd .
docker tag jr0sco/lnd jr0sco/lnd:lnd-${LND_VERSION} 
docker push jr0sco/lnd:lnd-${LND_VERSION}
