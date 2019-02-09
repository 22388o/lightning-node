#!/bin/bash

set -e

DATA_DIR=/data

if [[ ! -s "${DATA_DIR}/bitcoin.conf" ]]; then
    touch ${DATA_DIR}/bitcoin.conf
cat <<-EOF > ${DATA_DIR}/bitcoin.conf
    printtoconsole=1
    rpcallowip=${BITCOIN_RPC_ALLOWED:-127.0.0.1}
    rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
    rpcuser=${BITCOIN_RPC_USER:-bitcoin}
    rpcport=${BITCOIN_RPC_PORT:-8332}
    server=${BITCOIN_SERVER:-1}
    listen=${LISTEN:-1}
    testnet=${BITCOIN_TESTNET:-0}
    zmqpubrawblock=${ZMQ_PUB_RAW_BLK:-"tcp://127.0.0.1:28333"}
    zmqpubrawtx=${ZMQ_PUB_RAW_TX:-"tcp://127.0.0.1:28332"}
EOF
    chown -R 1000:1000 ${DATA_DIR}
fi

exec gosu bitcoin "$@"

