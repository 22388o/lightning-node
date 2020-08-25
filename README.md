# Lightning Node Docker Container Stack

Repo for spinning up your own Lightning Node Stack (bitcoind, lnd, neutrino)

## Bitcoin (bitcoind) Container

<!-- [![Build Status](https://travis-ci.org/jrosco/lightning-node.svg?branch=master)](https://travis-ci.org/jr0sco/lightning-node/)
[![ImageLayers](https://images.microbadger.com/badges/image/jr0sco/bitcoind.svg)](https://microbadger.com/#/images/jr0sco/bitcoind) -->
[![Bitcoind Docker Stars](https://img.shields.io/docker/stars/jr0sco/bitcoind.svg)](https://hub.docker.com/r/jr0sco/bitcoind/)
[![Bitcoind Docker Pulls](https://img.shields.io/docker/pulls/jr0sco/bitcoind.svg)](https://hub.docker.com/r/jr0sco/bitcoind/)

---
See [Dockerfile](./docker/bitcoind/Dockerfile)

### Bitcoin Dockerfile Build Argument Values

|Key|Default Values|Info|
|---|---|---|
|BITCOIN_VERSION|0.20.1|Bitcoin version to use|
|USER_ID|1000|bitcoin user UID. Make this the same as the local directory UID permissions |
|GROUP_ID|1000|bitcoin group GID. Make this the same as the local directory UID permissions |

### Bitcoin Container Environment Values

---

|Key|Default Values|Info|
|---|---|---|
|BITCOIN_SERVER|1|Enable(1) / Disable(0) Bitcoin server|
|LISTEN|1|Enable(1) / Disable(0) Bitcoin to listen|
|BITCOIN_TESTNET|"0"|Enable(1) / Disable(0) testnet (overrides bitcoin.conf value)|
|BITCOIN_RPC_ALLOWED|127.0.0.1|RPC Whitelist IPs addresses|
|BITCOIN_RPC_USER|bitcoin|The Bitcoin RPC user|
|BITCOIN_RPC_PASSWORD|randomly generated password|The Bitcoin RPC password|
|BITCOIN_RPC_PORT|8332|Bitcoin RPC Port |
|ZMQ_PUB_RAW_TX|tcp://127.0.0.1:28332|The ZeroMQ raw publisher transactions URL|
|ZMQ_PUB_RAW_BLK|tcp://127.0.0.1:28333|The ZeroMQ raw publisher blocks URL|
---

### Bitcoin Docker Build

---

```bash
docker build -t bitcoind docker/bitcoind/
```

Build with differnet Bitcoin version

```bash
docker build --build-arg BITCOIN_VERSION=0.16.3 -t bitcoind docker/bitcoind/
```

Build with different UID/GID

```bash
docker build --build-arg USER_ID=1001 --build-arg GROUP_ID=1001 -t bitcoind  docker/bitcoind/
```

---
Example Run bitcoind

```bash
docker run --name bitcoind -d \
    -v {local.bitcoin.dir}:/home/bitcoin \
    -v {local.bitcoin.config}:/home/bitcoin/.bitcoin/bitcoin.conf \
    -e TESTNET=1 \
    -p 0.0.0.0:9735:9735 \
    -p 127.0.0.1:28332:28332 \
    -p 127.0.0.1:28333:28333 \
    bitcoind
```

## Lightning (lnd) Container

<!-- [![Build Status](https://travis-ci.org/jrosco/lightning-node.svg?branch=master)](https://travis-ci.org/jr0sco/lightning-node/)
[![ImageLayers](https://images.microbadger.com/badges/image/jr0sco/bitcoind.svg)](https://microbadger.com/#/images/jr0sco/bitcoind) -->
[![Lightning Docker Stars](https://img.shields.io/docker/stars/jr0sco/lnd.svg)](https://hub.docker.com/r/jr0sco/lnd/)
[![Lightning Docker Pulls](https://img.shields.io/docker/pulls/jr0sco/lnd.svg)](https://hub.docker.com/r/jr0sco/lnd/)

---
See [Dockerfile](./docker/lnd/Dockerfile)

### Lightning Dockerfile Argument Values

|Key|Default Values|Info|
|---|---|---|
|LND_VERSION|v0.10.4-beta|Lightning version to use|
|USER_ID|1000|The run container as bitcoin UID. Make this the same as the local directory UID permissions|

### Lightning Container Environment Values

|Key|Default Values|Info|
|---|---|---|
|BITCOIN_RPC_USER|bitcoin|The Bitcoin RPC user|
|BITCOIN_RPC_PASSWORD|password |The Bitcoin RPC password|
|DEBUG|info|Logging level|
|NETWORK|testnet|Which network to use (testnet,simnet,mainnet)|
|CHAIN|bitcoin|Which blockchain to use (bitcoin,litecoin)|
|BACKEND|bitcoind|Which backend to use (bitcoind,btcd,litecoind,ltcd,neutrino )|
|ZMQ_PUB_RAW_TX|tcp://127.0.0.1:28332|The ZeroMQ raw publisher transactions URL|
|ZMQ_PUB_RAW_BLK|tcp://127.0.0.1:28333|The ZeroMQ raw publisher blocks URL|
|LIGHTNING_DATA|/data/.lnd|The Lightning .lnd directory location|

### Lightning Docker Build

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
Run Lightning with Bitcoin Backend

```bash
docker run --rm --name lnd --network container:bitcoind -d \
    -v {local.bitcoin.dir}:/home/bitcoin \
    -v :/data/.lnd \
    lnd
```

Run Lightning with Neutrino Backend

```bash
docker run --rm --name lnd -d \
    -e BACKEND=neutrino \
    -v {local.lightning.dir}:/data \
    -v :/data/.lnd \
    lnd
```

Build you own LND certificate:

---

```bash
cd ~/.lnd
openssl ecparam -genkey -name prime256v1 -out tls.key
openssl req -new -sha256 -key tls.key -out csr.csr -subj '/CN=localhost/O=lnd'
openssl req -x509 -sha256 -days 36500 -key tls.key -in csr.csr -out tls.cert
rm csr.csr
```
