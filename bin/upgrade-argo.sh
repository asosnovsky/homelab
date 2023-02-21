#!/bin/bash

helm upgrade argocd k8s/infra/argocd \
    --namespace argocd \
    --create-namespace \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)"