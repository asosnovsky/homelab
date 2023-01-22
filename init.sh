#!/bin/bash

k3d cluster create -v $(pwd)/.tmp:/mnt -p "443:443@loadbalancer" -p "80:80@loadbalancer"
mkdir -p .tmp/{redis,postgres,nextcloud}