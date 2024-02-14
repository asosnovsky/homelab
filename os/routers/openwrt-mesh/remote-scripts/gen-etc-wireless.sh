#!/bin/sh

MESH_PWD=$(echo "$MESH_PWD" | tr -d '"')
WIFI_PWD=$(echo "$WIFI_PWD" | tr -d '"')
output_file=${1:-"/etc/config/wireless"}

echo "writing to $output_file"

cat << EOF >> "$output_file"

config wifi-iface 'mesh'
	option device 'radio0'
	option disabled '0'
	option mode 'mesh'
	option ifname 'mesh0'
	option network 'lan'
	option mesh_id 'kosovsky-mesh'
	option encryption 'sae'
	option key '${MESH_PWD}'
	option mesh_fwding '1'
	option mesh_rssi_threshold '0'

config wifi-iface 'wifi5g'
	option ssid 'kosovsky-main'
	option disabled '0'
	option device 'radio2'
	option mode 'ap'
	option network 'lan'
	option encryption 'psk2'
	option key '${WIFI_PWD}'
	option ieee80211r '1'
	option mobility_domain '7da1'
	option ft_over_ds '0'

config wifi-iface 'wifi2g'
	option ssid 'kosovsky-main'
	option disabled '0'
	option device 'radio1'
	option mode 'ap'
	option network 'lan'
	option encryption 'psk2'
	option key '${WIFI_PWD}'
	option ieee80211r '1'
	option mobility_domain '3333'
	option ft_over_ds '0'
	option ft_psk_generate_local '1'

EOF