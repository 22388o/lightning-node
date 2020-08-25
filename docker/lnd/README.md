
# README

## Lightning Dockerfile Argument Values

|Key|Default Values|Info|
|---|---|---|
|LND_VERSION|v0.10.4-beta|Lightning version to use|
|USER_ID|1000|The run container as bitcoin UID. Make this the same as the local directory UID permissions|

## Lightning Container Environment Values

|Key|Default Values|Info|
|---|---|---|
|BITCOIN_RPC_USER|bitcoin|The Bitcoin RPC user|
|BITCOIN_RPC_PASSWORD|password |The Bitcoin RPC password|
|DEBUG|info|Logging level|
|NETWORK|mainnet|Which network to use (testnet,simnet,mainnet)|
|CHAIN|bitcoin|Which blockchain to use (bitcoin,litecoin)|
|BACKEND|bitcoind|Which backend to use (bitcoind,btcd,litecoind,ltcd,neutrino )|
|ZMQ_PUB_RAW_TX|tcp://127.0.0.1:28332|The ZeroMQ raw publisher transactions URL|
|ZMQ_PUB_RAW_BLK|tcp://127.0.0.1:28333|The ZeroMQ raw publisher blocks URL|
|ZMQ_PUB_HASH_BLK|tcp://127.0.0.1:28334|The ZeroMQ hash publisher blocks URL|
|LIGHTNING_DATA|/data/.lnd|The Lightning .lnd directory location|

## Lightning Docker Build

---

```bash
docker build -t lnd docker/lnd
```

Build with differnet Lightning version

```bash
docker build --build-arg LND_VERSION=v0.10.4-beta -t lnd docker/lnd
```

Build with different UID

```bash
docker build --build-arg USER_ID=1001 -t lnd docker/lnd
```

---
Example run Lightning with Bitcoin Backend (testnet)

```bash
docker run --name lnd --network container:bitcoind -d \
    -e NETWORK=testnet \
    -v {local.bitcoin.dir}:/home/bitcoin \
    lnd
```

Example run Lightning with Neutrino Backend (testnet)

```bash
docker run --name lnd -d \
    -e BACKEND=neutrino \
    -e NETWORK=testnet \
    -v {local.bitcoin.dir}:/home/bitcoin \
    lnd
```

### Build you own LND certificate:

---

```bash
cd ~/.lnd
openssl ecparam -genkey -name prime256v1 -out tls.key
openssl req -new -sha256 -key tls.key -out csr.csr -subj '/CN=localhost/O=lnd'
openssl req -x509 -sha256 -days 36500 -key tls.key -in csr.csr -out tls.cert
rm csr.csr
```
