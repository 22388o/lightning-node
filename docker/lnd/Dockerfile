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


# Copy the binaries and entrypoint from the builder image.
COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/

RUN addgroup bitcoin && adduser -D -G bitcoin -s /bin/bash bitcoin
# create data directory
ENV LIGHTNING_DATA /data
RUN mkdir "$LIGHTNING_DATA" \
    && chown -R bitcoin:bitcoin "$LIGHTNING_DATA" \
    && ln -sfn "$LIGHTNING_DATA" /home/bitcoin/.lnd \
    && chown -h bitcoin:bitcoin /home/bitcoin/.lnd

COPY lnd.conf /home/bitcoin/.lnd/lnd.conf 

# Add bash.
RUN apk add --no-cache \
    bash

# Copy the entrypoint script.
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose lnd ports (server, rpc).
EXPOSE 9735 10009

ENTRYPOINT ["/docker-entrypoint.sh"]
