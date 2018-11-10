#!/bin/bash

set -e

mkdir -p "${BITCOIN_DATA}"

if [[ ! -s "${BITCOIN_DATA}/bitcoin.conf" ]]; then
cat <<-EOF > "${BITCOIN_DATA}/bitcoin.conf"
    printtoconsole=1
    rpcallowip=${BITCOIN_RPC_ALLOWED:-127.0.0.1}
    rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
    rpcuser=${BITCOIN_RPC_USER:-bitcoin}
EOF
    chown -R 1000:1000 "${BITCOIN_DATA}"
fi

exec gosu bitcoin "$@"

