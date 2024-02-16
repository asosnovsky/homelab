#!/bin/bash
# Turn an OpenWrt dumb access point into a Wi-fi mesh point

# ######################
# you may customize this
# ######################

MESH_NAME="kososvsky-mesh"
MESH_RADIO=radio0
MESH_CHANNEL=1

WIFI_NAME="kososvsky-main"
WIFI_RADIO=radio1
WIFI_CHANNEL=36
WIFI_MOBDOMAIN='3333'


if [ -z ${MESH_PWD} ]; then
    echo "Missing 'MESH_PWD'"
    exit 1
else
    echo "MESH_NAME = ${MESH_NAME}"
    echo "MESH_PWD = ${MESH_PWD}"
fi
if [ -z ${WIFI_PWD} ]; then
    echo "Missing 'WIFI_PWD'"
    exit 1
else
    echo "WIFI_NAME = ${WIFI_NAME}"
    echo "WIFI_PWD = ${WIFI_PWD}"
fi

n=5
while [ "$n" -gt 0 ]; do
    echo "Starting in $n..."
    sleep 1
    n=$(( n - 1 ))
done

# install the wpad mesh package
opkg update
opkg install --force-overwrite wpad-mesh-openssl

# delete the "OpenWrt" radios
uci delete wireless.default_radio0
uci delete wireless.default_radio1

# create the mesh Wifi
uci set wireless.wifinet0=wifi-iface
uci set wireless.wifinet0.device="$MESH_RADIO"
uci set wireless.wifinet0.mode='mesh'
uci set wireless.wifinet0.encryption='sae'
uci set wireless.wifinet0.mesh_id="$MESH_NAME"
uci set wireless.wifinet0.mesh_fwding='1'
uci set wireless.wifinet0.mesh_rssi_threshold='0'
uci set wireless.wifinet0.key="$MESH_PWD"
uci set wireless.wifinet0.network='lan'
uci set "wireless.$MESH_RADIO.channel=$MESH_CHANNEL"
uci delete "wireless.$MESH_RADIO.disabled"   

# create the AP Wifi
uci set wireless.wifinet1=wifi-iface
uci set wireless.wifinet1.device=$WIFI_RADIO
uci set wireless.wifinet1.mode='ap'
uci set wireless.wifinet1.ssid=$WIFI_NAME
uci set wireless.wifinet1.encryption='psk2'
uci set wireless.wifinet1.key=$WIFI_PWD
uci set wireless.wifinet1.ieee80211r='1'
uci set wireless.wifinet1.mobility_domain=$WIFI_MOBDOMAIN
uci set wireless.wifinet1.ft_over_ds='0'
uci set wireless.wifinet1.ft_psk_generate_local='1'
uci set wireless.wifinet1.network='lan'
uci set "wireless.$WIFI_RADIO.channel"=$WIFI_CHANNEL
uci delete "wireless.$WIFI_RADIO.disabled"   

uci commit

wifi down
/etc/init.d/wpad restart
wifi up