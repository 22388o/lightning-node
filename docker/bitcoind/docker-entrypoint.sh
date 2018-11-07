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
    chown -R bitcoin:bitcoin "${BITCOIN_DATA}/"
fi

# ensure correct ownership and linking of data directory
# we do not update group ownership here, in case users want to mount
# a host directory and still retain access to it
chown -R bitcoin "${BITCOIN_DATA}"
ln -sfn "${BITCOIN_DATA}" /home/bitcoin/.bitcoin
chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

exec gosu bitcoin "$@"

