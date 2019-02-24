#!/usr/bin/env bash

# exit from script if error was raised.
set -e

# Set default variables if needed.
RPCUSER=${RPCUSER:-bitcoin}
RPCPASS=${RPCPASS:-password}
DEBUG=${DEBUG:-info}
NETWORK=${NETWORK:-simnet}
BTCD_DATA=${BTCD_DATA:-"/data"}
LISTEN=${LISTEN:-"0.0.0.0"}

PARAMS=$(echo \
    "--debuglevel=$DEBUG" \
    "--rpcuser=$RPCUSER" \
    "--rpcpass=$RPCPASS" \
    "--datadir=${BTCD_DATA}" \
    "--logdir=${BTCD_DATA}" \
    "--configfile=${BTCD_DATA}/btcd.conf" \
    "--rpccert=/rpc/rpc.cert" \
    "--rpckey=/rpc/rpc.key" \
    "--rpclisten=${LISTEN}" \
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

# start bitcoin node.
exec btcd $PARAMS

