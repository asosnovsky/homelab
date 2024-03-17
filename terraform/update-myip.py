import httpx
import json
import os
from pathlib import Path

MYIP_URL = os.environ.get("MYIP_URL", "https://api.myip.com/")
MYIP_KEY = os.environ.get("MYIP_KEY", "myip")

def get_auto_vars_file():
    if p := os.environ.get("AUTO_TFVARS", None):
        return Path(p)
    return Path(__file__).parent / "var.auto.tfvars.json"

auto_tfvars = get_auto_vars_file()

print("Starting ip-update with")
print(f" > auto_tfvars = {auto_tfvars}")
print(f" > MYIP_URL = {MYIP_URL}")
print(f" > MYIP_KEY = {MYIP_KEY}")

resp = httpx.get(MYIP_URL)

if resp.status_code != 200:
    raise AssertionError(f"{MYIP_URL} returned {resp}")

data = resp.json()
print(f"myip response = {data}")

myip = data['ip']

if not auto_tfvars.exists():
    raise AssertionError(f"{auto_tfvars} does not exists!")

auto_tfvars_data = json.loads(auto_tfvars.read_text())
auto_tfvars_data[MYIP_KEY] = myip
auto_tfvars.write_text(json.dumps(auto_tfvars_data, indent=4))

print("DONE")