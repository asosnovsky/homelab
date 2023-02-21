#!/bin/bash

# kubectl create namespace argocd
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

helm install argocd k8s/infra/argocd --namespace argocd --create-namespace 

watch -n1 "kubectl -n argocd get all"