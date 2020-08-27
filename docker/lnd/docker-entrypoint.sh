#!/usr/bin/env bash

# exit from script if error was raised.
set -e

LND_CONFIG_FILE="/home/bitcoin/.lnd/lnd.conf"

# Set default variables if needed.
BITCOIN_RPC_HOST=${BITCOIN_RPC_HOST:-localhost}
BITCOIN_RPC_USER=${BITCOIN_RPC_USER:-bitcoin}
BITCOIN_RPC_PASSWORD=${BITCOIN_RPC_PASSWORD:-password}
DEBUG=${DEBUG:-info}
NETWORK=${NETWORK:-mainnet}
CHAIN=${CHAIN:-bitcoin}
BACKEND=${BACKEND:-bitcoind}
ZMQ_PUB_RAW_TX=${ZMQ_PUB_RAW_TX:-"tcp://127.0.0.1:28332"}
ZMQ_PUB_RAW_BLK=${ZMQ_PUB_RAW_BLK:-"tcp://127.0.0.1:28333"}

if [ ! -s "${LND_CONFIG_FILE}" ]; then
    touch ${LND_CONFIG_FILE}
    chown bitcoin:bitcoin ${LND_CONFIG_FILE}
cat <<-EOF > "${LND_CONFIG_FILE}"
[Application Options]
maxpendingchannels=5

[autopilot]
autopilot.active=0
autopilot.maxchannels=5
autopilot.allocation=0.6
EOF
fi

if [ "$1" == "lnd" ]; then
  grep -e "^${CHAIN}.active=" ${LND_CONFIG_FILE} \
    || params=("${params[@]}" "--${CHAIN}.active")
  grep -e "^${CHAIN}.${NETWORK}=" ${LND_CONFIG_FILE} \
    || params=("${params[@]}" "--${CHAIN}.${NETWORK}")
  grep -e "^${CHAIN}.node=" ${LND_CONFIG_FILE} \
    || params=("${params[@]}" "--${CHAIN}.node=${BACKEND}")
  grep -e "^debuglevel=" ${LND_CONFIG_FILE} \
    || params=("${params[@]}" "--debuglevel=${DEBUG}")

  if echo ${BACKEND}|grep -q 'bitcoind\|btcd\|litecoind\|ltcd'; then
    grep -e "^${BACKEND}.rpchost=" ${LND_CONFIG_FILE} \
      || params=("${params[@]}" "--${BACKEND}.rpchost=${BITCOIN_RPC_HOST}")
    grep -e "^${BACKEND}.rpcuser=" ${LND_CONFIG_FILE} \
      || params=("${params[@]}" "--${BACKEND}.rpcuser=${BITCOIN_RPC_USER}")
    grep -e "^${BACKEND}.rpcpass=" ${LND_CONFIG_FILE} \
      || params=("${params[@]}" "--${BACKEND}.rpcpass=${BITCOIN_RPC_PASSWORD}")
  fi

  if echo ${BACKEND}|grep -q 'bitcoind\|litecoind'; then
    grep -e "^${BACKEND}.zmqpubrawblock" ${LND_CONFIG_FILE} \
      || params=("${params[@]}" "--${BACKEND}.zmqpubrawblock=${ZMQ_PUB_RAW_TX}")
    grep -e "^${BACKEND}.zmqpubrawtx" ${LND_CONFIG_FILE} \
      || params=("${params[@]}" "--${BACKEND}.zmqpubrawtx=${ZMQ_PUB_RAW_BLK}")
  fi
fi

su-exec bitcoin "$@" "${params[@]}"
