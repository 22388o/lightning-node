FROM debian:stretch-slim
LABEL MAINTAINER Joel Cumberland <j12d@jros.co>

ARG BITCOIN_VERSION=0.20.1
ARG USER_ID=1000
ARG GROUP_ID=1000

# install deps
RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget procps \
    && rm -rf /var/lib/apt/lists/*

# create user
RUN set -ex \
    && addgroup --gid ${GROUP_ID} bitcoin \
    && adduser --quiet --disabled-password --uid ${USER_ID} --gid ${GROUP_ID} bitcoin

# install bitcoin binaries
RUN set -ex \
    && BITCOIN_ARCHIVE=bitcoin-${BITCOIN_VERSION}-$(uname -m)-linux-gnu.tar.gz \
    && cd /tmp \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/${BITCOIN_ARCHIVE} \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
    && wget -q https://bitcoin.org/laanwj-releases.asc \
    && SHA256=`grep "${BITCOIN_ARCHIVE}" SHA256SUMS.asc | awk '{print $1}'` \
    && echo "$SHA256 ${BITCOIN_ARCHIVE}" | sha256sum -c - \
    && gpg --no-tty  --import ./laanwj-releases.asc \
    && gpg --no-tty  --verify SHA256SUMS.asc \
    && tar -xzf ${BITCOIN_ARCHIVE} -C /usr/local --strip-components=1 --exclude=*-qt \
    && rm -rf /tmp/* \
    && bitcoind --version    

# Copy the entrypoint script.
COPY docker-entrypoint.sh /
RUN set -ex \ 
    && chmod +x /docker-entrypoint.sh

# mainnet and testnet ports (rpc, http)
EXPOSE 8332 8333

# mainnet and testnet zmq interfaces (block, tx)
EXPOSE 18332 18333 28332 28333

# Bitcoin work directory
WORKDIR /home/bitcoin/.bitcoin/
RUN set -ex \ 
    & chown bitcoin:bitcoin /home/bitcoin/.bitcoin/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bitcoind"]
