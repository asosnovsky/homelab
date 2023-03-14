#!/bin/bash
set -e 

pushd k8s/argocd

helm dependency update

popd

helm install argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --values k8s/argocd/values.yaml \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)" \
    --set selfapp.deployment=dev

watch -n1 "kubectl -n argocd get all"

argocd login cd.argoproj.io --core
kubectl config set-context --current --namespace argocd
argocd admin initial-password

helm upgrade argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --values k8s/argocd/values.yaml \
    --set selfapp.enabled="true" \
    --set selfapp.deployment=dev \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)"
