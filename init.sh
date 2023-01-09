#!/bin/bash

k3d cluster create -v $(pwd)/.tmp:/mnt
helm repo add bitnami https://charts.bitnami.com/bitnami 
mkdir -p .tmp/{redis,postgres}