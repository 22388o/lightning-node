# Lightning Node Docker Containers Stack

Repo for spinning up your own Lightning Node Stack (bitcoind, lnd)

Bitcoin (bitcoind) Docker Build

---

```bash
docker build -t bitcoind .
```

Run bitcoind

```bash
docker run --name bitcoind -d \
    --env-file /data/.bitcoin/.env \
    -v {local.bitcoin.dir}:/data \
    -p 0.0.0.0:9735:9735 \
    -p 127.0.0.1:28332:28332 \
    -p 127.0.0.1:28333:28333 \
    bitcoind
```

Lightning (lnd) Docker Build

---

```bash
docker build -t lnd .
```

Run lnd

```bash
docker run --rm --name lnd --network container:bitcoind -d \
    --env-file ~/data/.lnd/.env \
    -v {local.bitcoin.dir}:/data \
    -v :/data/.lnd \
    lnd
```

LND generate new certificate:

---

```bash
cd ~/.lnd
openssl ecparam -genkey -name prime256v1 -out tls.key
openssl req -new -sha256 -key tls.key -out csr.csr -subj '/CN=localhost/O=lnd'
openssl req -x509 -sha256 -days 36500 -key tls.key -in csr.csr -out tls.cert
rm csr.csr
```