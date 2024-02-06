#!/usr/bin/env python
from pathlib import Path

import yaml

BASE_PATH = Path(__file__).parent
CONFIG_FILE = BASE_PATH / "config.yaml"
OUTPUT_FOLDER = BASE_PATH / "output"
DNSMASQ_CONF = OUTPUT_FOLDER / "var" / "dnsmasq.conf"

DNSMASQ_CONF.parent.mkdir(exist_ok=True, parents=True)

root_domain = "internal"
ip_prefix_map = {
    "lab": "10.0.10.",
    "k3s": "10.0.11.",
    "hub": "10.0.12.",
    "cam": "10.0.13.",
}

with CONFIG_FILE.open('r') as fp:
    devices = yaml.safe_load(fp)

with DNSMASQ_CONF.open('w') as fp:
    for sub_domain, configs in devices.items():
        ip_prefix = ip_prefix_map[sub_domain]
        for ip_suffix, dvc in enumerate(configs, start=1):
            mac = dvc['mac']
            name = dvc['name']
            ip = f"{ip_prefix}{ip_suffix}"
            host = f"{name}.{sub_domain}.{root_domain}"
            fp.write(f"dhcp-host={mac},{name}{sub_domain},{ip},infinite\n")
            fp.write(f"address=/{host}/{ip}\n")
            if domain := dvc.get('domain'):
                fp.write(f"address=/{domain}/{ip}\n")
                fp.write(f"address=/.{domain}/{ip}\n")
