#!/bin/bash

helm upgrade argocd k8s/argocd \
    --namespace argocd \
    --create-namespace \
    --set selfapp.sshkey="$(cat ~/.ssh/id_rsa)" \
    --set selfapp.enabled="true"