#!/usr/bin/env sh

# exit from script if error was raised.
set -e

# Set default variables if needed.
BITCOIN_RPC_USER=${BITCOIN_RPC_USER:-bitcoin}
BITCOIN_RPC_PASSWORD=${BITCOIN_RPC_PASSWORD:-password}
DEBUG=${DEBUG:-info}
NETWORK=${NETWORK:-mainnet}
CHAIN=${CHAIN:-bitcoin}
BACKEND=${BACKEND:-bitcoind}
ZMQ_PUB_RAW_TX=${ZMQ_PUB_RAW_TX:-"tcp://127.0.0.1:28332"}
ZMQ_PUB_RAW_BLK=${ZMQ_PUB_RAW_BLK:-"tcp://127.0.0.1:28333"}
LIGHTNING_DATA=${LIGHTNING_DATA:-"/data/.lnd"}
if [[ "${CHAIN}" == "litecoin" ]]; then
    BACKEND="ltcd"
fi

PARAMS=$(echo \
    "--${CHAIN}.active" \
    "--${CHAIN}.${NETWORK}" \
    "--${CHAIN}.node=${BACKEND}" \
    "--${BACKEND}.rpcuser=${BITCOIN_RPC_USER}" \
    "--${BACKEND}.rpcpass=${BITCOIN_RPC_PASSWORD}" \
    "--${BACKEND}.zmqpubrawblock=${ZMQ_PUB_RAW_TX}" \
    "--${BACKEND}.zmqpubrawtx=${ZMQ_PUB_RAW_BLK}" \
    "--debuglevel=${DEBUG}" \
    "--lnddir=${LIGHTNING_DATA}" \
    "--configfile=${LIGHTNING_DATA}/lnd.conf" \
    "--bitcoind.dir=/data/"
)

if [[ ! -s "${LIGHTNING_DATA}/lnd.conf" ]]; then
    mkdir -p ${LIGHTNING_DATA}; touch ${LIGHTNING_DATA}/lnd.conf
cat <<-EOF > "${LIGHTNING_DATA}/lnd.conf"
    [Application Options]
    maxpendingchannels=5

    [autopilot]
    autopilot.maxchannels=5
    autopilot.allocation=0.6
EOF
    chown -R 1000:1000 "${LIGHTNING_DATA}/"
fi

su bitcoin -c "lnd ${PARAMS} $@"