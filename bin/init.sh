RUNAS=${RUNAS:=bitcoin}
MNTVOL=${MNTVOL:='/scratch/bitcoin/mainnet'}
DEVICE=${DEVICE:='/dev/sda'}
BTCIMAGE=${BTCIMAGE:='jr0sco/bitcoind:latest'}
BTCNAME=${BTCNAME:=bitcoind}
LNDIMAGE=${LNDIMAGE:='jr0sco/lnd:latest'}
LNDNAME=${LNDNAME:=lightning}
APPDIR=${APPDIR:='/opt/lightning-node'}

mkdir -p ${MNTVOL}/${LNDNAME}
mkdir -p ${MNTVOL}/${BTCNAME}

# mountpoint ${MNTVOL} || exit

function waitforblock() {
    while true; do
        LOCALBLK=$(docker exec -it ${BTCNAME} su ${RUNAS} -c "bitcoin-cli getblockchaininfo|grep blocks|cut -d: -f2|cut -d, -f1 | tr -dc '[:alnum:]\n\r'")
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