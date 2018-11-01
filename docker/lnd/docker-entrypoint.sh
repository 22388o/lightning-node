#!/usr/bin/env bash

# exit from script if error was raised.
set -e

# Set default variables if needed.
BITCOIN_RPC_USER=${BITCOIN_RPC_USER:-bitcoin}
BITCOIN_RPC_PASSWORD=${BITCOIN_RPC_PASSWORD:-password}
DEBUG=${DEBUG:-debug}
NETWORK=${NETWORK:-mainnet}
CHAIN=${CHAIN:-bitcoin}
BACKEND=${BACKEND:-bitcoind}
if [[ "${CHAIN}" == "litecoin" ]]; then
    BACKEND="ltcd"
fi

su bitcoin -c "lnd \
    --noseedbackup \
    --${CHAIN}.active \
    --${CHAIN}.${NETWORK} \
    --${CHAIN}.node=${BACKEND} \
    --${BACKEND}.rpcuser=${BITCOIN_RPC_USER} \
    --${BACKEND}.rpcpass=${BITCOIN_RPC_PASSWORD} \
    --${BACKEND}.zmqpubrawblock=tcp://127.0.0.1:28332 \
    --${BACKEND}.zmqpubrawtx=tcp://127.0.0.1:28333 \
    --debuglevel=${DEBUG} \
    $@"
