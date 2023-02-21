#!/bin/bash

helm install argocd k8s/infra/argocd \
    --namespace argocd \
    --create-namespace \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)"

watch -n1 "kubectl -n argocd get all"