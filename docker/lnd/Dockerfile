FROM golang:1.10-alpine as builder

# Copy in the local repository to build from.
COPY lnd_src/ /go/src/github.com/lightningnetwork/lnd

# Force Go to use the cgo based DNS resolver. This is required to ensure DNS
# queries required to connect to linked containers succeed.
ENV GODEBUG netdns=cgo

# Install dependencies and install/build lnd.
RUN apk add --no-cache \
    git \
    make \
&&  cd /go/src/github.com/lightningnetwork/lnd \
&&  make \
&&  make install

# Start a new, final image to reduce size.
FROM alpine as final

ENV LIGHTNING_DATA /data

# Copy the binaries and entrypoint from the builder image.
COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/

RUN addgroup -g 1000 bitcoin && adduser -u 1000 -D -G bitcoin -s /bin/sh bitcoin
# create data directory
RUN set -ex \
    && mkdir "$LIGHTNING_DATA" \
    && chown -R 1000:1000 "$LIGHTNING_DATA" \
    && ln -sfn "$LIGHTNING_DATA" /home/bitcoin/.lnd \
    && chown -R 1000:1000 "$LIGHTNING_DATA" \
    && chown -h 1000:1000 /home/bitcoin/.lnd

# Add bash.
RUN apk add --no-cache \
    bash

VOLUME /data

# Copy the entrypoint script.
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose lnd ports (server, rpc).
EXPOSE 9735 10009

ENTRYPOINT ["/docker-entrypoint.sh"]
