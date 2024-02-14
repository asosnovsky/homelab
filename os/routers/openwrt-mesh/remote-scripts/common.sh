#!/bin/bash

opkg update --no-check-certificate
opkg remove wpad-basic-*
opkg install --force-overwrite \
    --no-check-certificate \
    wpad-openssl
uci set system.@system[0].hostname="${HOSTNAME}"
uci commit
