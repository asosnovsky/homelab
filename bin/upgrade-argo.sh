#!/bin/bash

helm upgrade argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --values k8s/argocd/values.yaml \
    --set selfapp.deployment=dev \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)" \
    --set selfapp.enabled="true"