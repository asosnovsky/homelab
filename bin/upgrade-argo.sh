#!/bin/bash

DEPLOYMENT=dev

helm upgrade argocd k8s/argocd \
    --debug \
    --namespace argocd \
    --create-namespace \
    --values k8s/argocd/values.yaml \
    --values k8s/argocd/values-$DEPLOYMENT.yaml \
    --set selfapp.enabled="true" \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)" 