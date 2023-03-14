#!/bin/bash

mkdir -p .tmp

helm template argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --values k8s/argocd/values.yaml \
    --values k8s/argocd/values-dev.yaml \
    --set selfapp.enabled="true" \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)" \
    > .tmp/argocd.yaml