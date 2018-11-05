# FROM ubuntu
FROM python:3.6.7-slim

# https://github.com/kyuupichan/electrumx/blob/master/electrumx/lib/coins.py
ENV COIN BitcoinSegwit
# https://electrumx.readthedocs.io/en/latest/environment.html#envvar-DB_DIRECTORY
ENV DAEMON_URL electrumx:password@127.0.0.1
# https://electrumx.readthedocs.io/en/latest/environment.html#envvar-DAEMON_URL
ENV DB_DIRECTORY /home/electrumx

RUN groupadd -r electrumx && useradd -r -m -g electrumx electrumx

RUN apt update && \
        apt install -y \
        python3-pip \
        build-essential libc6-dev \
        libncurses5-dev libncursesw5-dev \
        libreadline6-dev \
        libleveldb-dev \
        git && \
    rm -rf /var/cache/apt/

RUN pip3 install plyvel

RUN git clone https://github.com/kyuupichan/electrumx.git /opt/electrumx && \
    cd /opt/electrumx && \
    python3 setup.py install

ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]