#!/bin/bash
set -e 

pushd k8s/argocd

helm dependency build

popd

helm install argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)"

watch -n1 "kubectl -n argocd get all"

argocd admin initial-password