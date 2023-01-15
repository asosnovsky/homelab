#!/bin/bash

k3d cluster create -v $(pwd)/.tmp:/mnt -p "443:443@loadbalancer" -p "80:80@loadbalancer"
helm repo add bitnami https://charts.bitnami.com/bitnami 
mkdir -p .tmp/{redis,postgres}