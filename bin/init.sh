BTCVOL='/scratch/bitcoin/mainnet/bitcoind'
DEVICE=/dev/sda
BTCIMAGE='jr0sco/btcd:latest'
BTCNAME='bitcoind'
LNDVOL='/scratch/bitcoin/mainnet/clightning/'
LNDIMAGE='jr0sco/lnd:latest'
LNDNAME='lightning'

mkdir -p ${BTCVOL}
mkdir -p ${LNDVOL}

function waitforblock() {
    while true; do
        LOCALBLK=$(docker exec -it ${BTCNAME} bitcoin-cli getblockchaininfo|grep blocks|cut -d: -f2|cut -d, -f1)
        CURRENTBLK=$(curl -s https://blockchain.info/q/getblockcount)
        test -z ${LOCALBLK} && LOCALBLK=0
        if [ ${LOCALBLK} == ${CURRENTBLK} ]; then
            echo "blocks synced ${LOCALBLK}/${CURRENTBLK}"
            break;
        else
            echo "waiting for blocks to sync ${LOCALBLK}/${CURRENTBLK}"
            sleep 1
        fi
    done
}