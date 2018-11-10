#!/bin/sh

BTC_VERSION=$(grep 'ENV BITCOIN_VERSION' Dockerfile | awk {'print $3'})

docker build -t jr0sco/bitcoind .
docker build -t jr0sco/bitcoind:btc-${BTC_VERSION} .

docker push jr0sco/bitcoind
docker push jr0sco/bitcoind:btc-${BTC_VERSION}
