# README

## Bitcoin Dockerfile Build Argument Values

|Key|Default Values|Info|
|---|---|---|
|BITCOIN_VERSION|0.20.1|Bitcoin version to use|
|USER_ID|1000|bitcoin user UID. Make this the same as the local directory UID permissions |
|GROUP_ID|1000|bitcoin group GID. Make this the same as the local directory UID permissions |

## Bitcoin Container Environment Values

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

## Bitcoin Docker Build

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
Example Run bitcoind (testnet)

```bash
docker run --name bitcoind -d \
    -v {local.bitcoin.dir}:/home/bitcoin \
    -e TESTNET=1 \
    -e BITCOIN_RPC_PORT=18332 \
    -p 0.0.0.0:9735:9735 \
    -p 127.0.0.1:18332:18332 \
    -p 127.0.0.1:28332:28332 \
    -p 127.0.0.1:28333:28333 \
    bitcoind
```
