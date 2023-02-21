#!/bin/bash

mkdir -p .tmp

helm template argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)" > .tmp/argocd.yaml