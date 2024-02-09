#!/usr/bin/env python
import shutil
from pathlib import Path

import yaml

BASE_PATH = Path(__file__).parent
CONFIG_FILE = BASE_PATH / "config.yaml"
OUTPUT_FOLDER = BASE_PATH / "output"
DNSMASQ_CONF = OUTPUT_FOLDER / "etc/dnsmasq.conf"
ETHERS = OUTPUT_FOLDER / "etc/ethers"
SUMMARY = OUTPUT_FOLDER / "summary.yaml"

shutil.rmtree(OUTPUT_FOLDER)
DNSMASQ_CONF.parent.mkdir(exist_ok=True, parents=True)
ETHERS.parent.mkdir(exist_ok=True, parents=True)

root_domain = "internal"
ip_prefix_map = {
    "lab": "10.0.10.",
    "k3s": "10.0.11.",
    "hub": "10.0.12.",
    "cam": "10.0.13.",
    "iot": "10.0.14.",
    "apl": "10.0.15."
}

def cap1_and_join(*args: str) -> str:
    out = ""
    for a in args:
        out += a[0].upper()
        out += a[1:].lower()
    return out

with CONFIG_FILE.open('r') as fp:
    devices = yaml.safe_load(fp)

with DNSMASQ_CONF.open('w') as dfp, SUMMARY.open('w') as sfp, ETHERS.open('w') as efp:
    for sub_domain, configs in devices.items():
        ip_prefix = ip_prefix_map[sub_domain]
        sfp.write(f'\n{cap1_and_join(sub_domain)}:')
        efp.write(f'#{cap1_and_join(sub_domain)}\n')
        for ip_suffix, dvc in enumerate(configs, start=1):
            mac = dvc['mac']
            name = dvc['name']
            sfp.write(f'\n   {cap1_and_join(name)}:')
            ip = f"{ip_prefix}{ip_suffix}"
            host = f"{name}.{sub_domain}.{root_domain}"
            sfp.write(f'\n       ip: "{ip}"')
            sfp.write(f'\n       host: "{host}"')
            # dfp.write(f"dhcp-host={mac},{cap1_and_join(sub_domain, name)},{ip},infinite\n")
            # dfp.write(f"address=/{host}/{ip}\n")
            efp.write(f'{mac} {ip}\n')
            efp.write(f'{mac} {host}\n')
            if domain := dvc.get('domain'):
                dfp.write(f"address=/{domain}/{ip}\n")
                dfp.write(f"address=/.{domain}/{ip}\n")
                sfp.write(f'\n       domain: "{domain}"')
                # efp.write(f'{mac} {domain}\n')