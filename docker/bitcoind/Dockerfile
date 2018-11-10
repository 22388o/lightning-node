FROM debian:stretch-slim

ENV BITCOIN_VERSION 0.17.0.1
ENV BITCOIN_DATA /data

RUN adduser --disabled-password --uid 1000 bitcoin --quiet

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
RUN set -ex \ 
    && mkdir "$BITCOIN_DATA" \
    && su bitcoin -c "mkdir -p /home/bitcoin/.bitcoin" \
    && ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin \
    && chown -R 1000:1000 "$BITCOIN_DATA" \
    && chown -h 1000:1000 /home/bitcoin/.bitcoin

VOLUME /data

ADD docker-entrypoint.sh /

EXPOSE 8332 8333

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bitcoind"]
