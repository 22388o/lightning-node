#!/usr/bin/env sh

# exit from script if error was raised.
set -e

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

COMMON_PARAMS=$(echo \
    "--${CHAIN}.active" \
    "--${CHAIN}.${NETWORK}" \
    "--${CHAIN}.node=${BACKEND}" \
    "--debuglevel=${DEBUG}" \
)

if echo ${BACKEND}|grep -q 'bitcoind\|btcd\|litecoind\|ltcd'; then
    BITCOIN_PARAMS=$(echo \
    "--${BACKEND}.rpchost=${BITCOIN_RPC_HOST}" \
    "--${BACKEND}.rpcuser=${BITCOIN_RPC_USER}" \
    "--${BACKEND}.rpcpass=${BITCOIN_RPC_PASSWORD}" \
    "--${BACKEND}.dir=/home/bitcoin"
    )
fi

if echo ${BACKEND}|grep -q 'bitcoind\|litecoind'; then
    ZMQ_PARAMS=$(echo \
    "--${BACKEND}.zmqpubrawblock=${ZMQ_PUB_RAW_TX}" \
    "--${BACKEND}.zmqpubrawtx=${ZMQ_PUB_RAW_BLK}" \
    )
fi

if [ ! -s "/home/bitcoin/.lnd/lnd.conf" ]; then
    touch /home/bitcoin/.lnd/lnd.conf
    chown bitcoin:bitcoin /home/bitcoin/.lnd/lnd.conf
cat <<-EOF > "/home/bitcoin/.lnd/lnd.conf"
    [Application Options]
    maxpendingchannels=5

    [autopilot]
    autopilot.active=0
    autopilot.maxchannels=5
    autopilot.allocation=0.6
EOF
fi

su bitcoin -c "lnd ${COMMON_PARAMS} \
    ${BITCOIN_PARAMS} \
    ${ZMQ_PARAMS}" \
    "$@"
