#!/bin/sh

# VERSION=${1:-"0.17.0.1"}

# docker build --build-arg BITCOIN_VERSION="${VERSION}" -t bitcoind .

# docker tag bitcoind jr0sco/bitcoind:"${VERSION}"
# docker push jr0sco/bitcoind:"${VERSION}"

# docker tag bitcoind jr0sco/bitcoind:latest
# docker push jr0sco/bitcoind:latest


VERSION=(0.20.1 
  0.20.0
  0.19.1
  0.19.0.1
  0.19.0
  0.18.1
  0.18.0
  0.17.1
  0.17.0
  0.16.3
  0.16.2
  0.16.1
  0.16.0
  0.15.1
  0.15.0
)

for i in "${VERSION[@]}"
do
  echo "build version $i"
  docker build --build-arg BITCOIN_VERSION="${i}" -t bitcoind .
  docker tag bitcoind jr0sco/bitcoind:"${i}"
  docker push jr0sco/bitcoind:"${i}"
done

# 0.14.2
# 0.14.1
# 0.14.0
# 0.13.2
# 0.13.1
# 0.13.0
# 0.12.1
# 0.12.0
# 0.11.2
# 0.11.1
# 0.11.0
# 0.10.4
# 0.10.3
# 0.10.2
# 0.10.1
# 0.10.0
