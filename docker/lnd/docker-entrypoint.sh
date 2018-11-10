#!/usr/bin/env bash

# exit from script if error was raised.
set -e

# Set default variables if needed.
BITCOIN_RPC_USER=${BITCOIN_RPC_USER:-bitcoin}
BITCOIN_RPC_PASSWORD=${BITCOIN_RPC_PASSWORD:-password}
DEBUG=${DEBUG:-debug}
NETWORK=${NETWORK:-testnet}
CHAIN=${CHAIN:-bitcoin}
BACKEND=${BACKEND:-bitcoind}
ZMQ_PUB_RAW_TX=${ZMQ_PUB_RAW_TX:-"tcp://127.0.0.1:8332"}
ZMQ_PUB_RAW_BLK=${ZMQ_PUB_RAW_BLK:-"tcp://127.0.0.1:8333"}
if [[ "${CHAIN}" == "litecoin" ]]; then
    BACKEND="ltcd"
fi

mkdir -p "${LIGHTNING_DATA}"

if [[ ! -s "${LIGHTNING_DATA}/lnd.conf" ]]; then
cat <<-EOF > "${LIGHTNING_DATA}/lnd.conf"
        [Application Options]
        debuglevel=${DEBUG}
        maxpendingchannels=5

        [Bitcoin]
        bitcoin.active=1
        # enable either testnet or mainnet
        bitcoin.${NETWORK}=1
        bitcoin.node=${BACKEND}

        [autopilot]
        autopilot.active=1
        autopilot.maxchannels=5
        autopilot.allocation=0.6
EOF
    chown -R 1000:1000 "${LIGHTNING_DATA}/"
fi

su bitcoin -c "lnd \
    --noseedbackup \
    --${CHAIN}.active \
    --${CHAIN}.${NETWORK} \
    --${CHAIN}.node=${BACKEND} \
    --${BACKEND}.rpcuser=${BITCOIN_RPC_USER} \
    --${BACKEND}.rpcpass=${BITCOIN_RPC_PASSWORD} \
    --${BACKEND}.zmqpubrawblock=${ZMQ_PUB_RAW_TX} \
    --${BACKEND}.zmqpubrawtx=${ZMQ_PUB_RAW_BLK} \
    --debuglevel=${DEBUG} \
    $@"