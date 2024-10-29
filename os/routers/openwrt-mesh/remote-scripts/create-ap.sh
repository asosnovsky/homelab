#!/usr/bin/env bash

HOSTNAME=${1:-$HOSTNAME}

echo "Configuring AP to $HOSTNAME"

n=5
while [ "$n" -gt 0 ]; do
    echo "Starting in $n..."
    sleep 1
    n=$(( n - 1 ))
done

for i in firewall dnsmasq odhcpd; do
    if /etc/init.d/"$i" enabled; then
        /etc/init.d/"$i" disable
        /etc/init.d/"$i" stop
    fi
done

uci set network.lan.proto='dhcp'
uci delete network.wan
uci delete network.wan6
uci delete network.lan.ipaddr
uci delete network.lan.netmask

mv /etc/config/firewall /etc/config/firewall.unused

reboot