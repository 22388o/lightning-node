#!/bin/sh

VERSION=${1:-"0.20.1"}

docker build --build-arg BITCOIN_VERSION="${VERSION}" -t bitcoind .

docker tag bitcoind jr0sco/bitcoind:"${VERSION}"
docker push jr0sco/bitcoind:"${VERSION}"

docker tag bitcoind jr0sco/bitcoind:latest
docker push jr0sco/bitcoind:latest
