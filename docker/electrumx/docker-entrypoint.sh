#!/bin/sh

electrumx_server=$(which electrumx_server)
user=electrumx

su ${user} -c "${electrumx_server} $@"