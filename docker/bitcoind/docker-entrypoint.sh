#!/bin/bash

# exit from script if error was raised.
set -e

BITCOIN_CONFIG_FILE=/home/bitcoin/.bitcoin/bitcoin.conf

# check if bitcoin.conf needs to be created
if [[ ! -s "${BITCOIN_CONFIG_FILE}" ]]; then
    touch "${BITCOIN_CONFIG_FILE}"
    chown bitcoin:bitcoin "${BITCOIN_CONFIG_FILE}"
cat <<-EOF > "${BITCOIN_CONFIG_FILE}"
printtoconsole=1
rpcallowip=${BITCOIN_RPC_ALLOWED:-"127.0.0.1"}
rpcpassword=${RPCPASSWORD:-$(dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64)}
server=${BITCOIN_SERVER:-1}
listen=${LISTEN:-1}
EOF
fi

# setup bitcoind parameters
if [ "$1" == "bitcoind" ]; then
  grep -e "^rpcuser=" ${BITCOIN_CONFIG_FILE} \
    || params=("${params[@]}" "--rpcuser=${BITCOIN_RPC_USER:-bitcoin}")
  grep -e "^rpcport=" ${BITCOIN_CONFIG_FILE} \
    || params=("${params[@]}" "--rpcport=${BITCOIN_RPC_PORT:-8332}")
  grep -e "^zmqpubrawblock=" ${BITCOIN_CONFIG_FILE} \
    || params=("${params[@]}" "--zmqpubrawblock=${ZMQ_PUB_RAW_BLK:-"tcp://127.0.0.1:28333"}")
  grep -e "^zmqpubrawtx=" ${BITCOIN_CONFIG_FILE} \
    || params=("${params[@]}" "--zmqpubrawtx=${ZMQ_PUB_RAW_TX:-"tcp://127.0.0.1:28332"}")
  test -n "${TESTNET}" \
    && params=("${params[@]}" --testnet="${TESTNET}")

fi

exec gosu bitcoin "$@" "${params[@]}"
