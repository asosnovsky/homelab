#!/bin/bash
set -e 

pushd k8s/argocd

helm dependency update

popd

helm install argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)"

watch -n1 "kubectl -n argocd get all"

k config set-context --current --namespace argocd
argocd admin initial-password