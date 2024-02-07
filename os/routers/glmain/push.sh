#!/usr/bin/env bash

BASE_PATH=$(realpath "${BASH_SOURCE[0]}" | xargs dirname)

ROUTER=${1:-10.0.0.1}
USER=${2:-root}

function ask {
    q=${1:-"Are you sure"}
    echo 
    read -p "$q? [Y/N]" -n 1 -r
    echo 
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Continuing..."
    else
        echo "Stopping!"
        exit 1
    fi
}


server=$USER@$ROUTER
pushd "$BASE_PATH" || exit 1
echo "using 🤖 $server"
ask "continue update"

echo "Updating conf..."
./gen-mappings.py
cat output/summary.yaml
ask "continue update"

scp -O output/etc/dnsmasq.conf  "$server:/tmp/dnsmasq.new.conf"
ssh "$server" << EOF
echo 'Backing up dnsmasq.conf file to /tmp/dnsmasq.old.conf'
cp /etc/dnsmasq.conf /tmp/dnsmasq.old.conf
echo 'Updating dnsmasq.conf 🙇🏼'
cp /tmp/dnsmasq.new.conf /etc/dnsmasq.conf 
if dnsmasq --test ; then 
    /etc/init.d/dnsmasq restart
else
    echo "Updated Failed! 🚨"
    echo "Attempting to revert back..."
    cp /tmp/dnsmasq.old.conf /etc/dnsmasq.conf 
    dnsmasq --test
    echo "Revert successful! 👍"
fi
EOF

git add .
git commit -m "🤖 Updated Router Config at $(date)"
git push