FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin
ENV BITCOIN_VERSION 0.17.0.1

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget procps \
    && rm -rf /var/lib/apt/lists/*

# install bitcoin binaries
RUN set -ex \
    && BITCOIN_ARCHIVE=bitcoin-${BITCOIN_VERSION}-$(uname -m)-linux-gnu.tar.gz \
    && cd /tmp \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/${BITCOIN_ARCHIVE} \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
    && wget -q https://bitcoin.org/laanwj-releases.asc \
    && SHA256=`grep "${BITCOIN_ARCHIVE}" SHA256SUMS.asc | awk '{print $1}'` \
    && echo "$SHA256 ${BITCOIN_ARCHIVE}" | sha256sum -c - \
    && gpg --import ./laanwj-releases.asc \
    && gpg --verify SHA256SUMS.asc \
    && tar -xzf ${BITCOIN_ARCHIVE} -C /usr/local --strip-components=1 --exclude=*-qt \
    && rm -rf /tmp/* \
    && bitcoind --version    

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
    && chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
    && ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin \
    && chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 28332 28333

ENTRYPOINT ["/docker-entrypoint.sh"]
