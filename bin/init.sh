BTCVOL='/scratch/bitcoin/mainnet/bitcoind'
DEVICE=/dev/sda
BTCIMAGE='lnd1/bitcoind:latest'
LNDVOL='/scratch/bitcoin/mainnet/clightning/'
LNDIMAGE='cdecker/lightningd:latest'

mkdir -p ${BTCVOL}
mkdir -p ${LNDVOL}

function waitforblock() {
    while true; do
        LOCALBLK=$(docker run --network container:bitcoind_mainnet lnd1/bitcoind:latest bitcoin-cli getblockchaininfo|grep blocks|cut -d: -f2|cut -d, -f1)
        CURRENTBLK=$(curl https://blockchain.info/q/getblockcount)
        echo "Local block is ${LOCALBLK} Current block is ${CURRENTBLK}"
        if [ ${LOCALBLK} == ${CURRENTBLK} ]; then
            echo "blocks synced ${LOCALBLK}/${CURRENTBLK}"
            break;
        else
            echo "waiting for blocks to sync ${LOCALBLK}/${CURRENTBLK}"
            sleep 1
        fi
    done
}