#!/usr/bin/env bash

# exit from script if error was raised.
set -e

# Set default variables if needed.
RPCUSER=${RPCUSER:-bitcoin}
RPCPASS=${RPCPASS:-password}
DEBUG=${DEBUG:-info}
NETWORK=${NETWORK:-simnet}
BTCD_DATA=${BTCD_DATA:-"/data/.btcd"}

PARAMS=$(echo \
    "--debuglevel=$DEBUG" \
    "--rpcuser=$RPCUSER" \
    "--rpcpass=$RPCPASS" \
    "--datadir=/data" \
    "--logdir=/data" \
    "--configfile=/data/.btcd/btcd.conf" \
    "--rpccert=/rpc/rpc.cert" \
    "--rpckey=/rpc/rpc.key" \
    "--rpclisten=0.0.0.0" \
    "--txindex"
)

if [[ ! -s "${BTCD_DATA}/btcd.conf" ]]; then
    mkdir -p ${BTCD_DATA}; touch ${BTCD_DATA}/btcd.conf
cat <<-EOF > "${BTCD_DATA}/btcd.conf"
EOF
    chown -R 1000:1000 "${BTCD_DATA}/"
fi

# Add user parameters to command.
PARAMS="$PARAMS $@"

# Print command and start bitcoin node.
echo "Command: btcd $PARAMS"
exec btcd $PARAMS

