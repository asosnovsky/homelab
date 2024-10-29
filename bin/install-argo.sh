#!/usr/bin/env bash
set -e

pushd k8s/argocd

echo "Installing dependencies..."
helm dependency update

popd

DEPLOYMENT=${1:-dev}

echo "Installing initial Chart..."
helm install argocd k8s/argocd \
--namespace argocd \
--create-namespace \
--values k8s/argocd/values.yaml \
--set selfapp.deployment="${DEPLOYMENT}" \
--set selfapp.sshkey="$(cat ~/.ssh/github_ed)"

echo "Waiting on argo to get started"
watch -n1 "kubectl -n argocd get all"

echo "Login to argo"
argocd login cd.argoproj.io --core
kubectl config set-context --current --namespace argocd
argocd admin initial-password

echo "Enabling selfapp"
helm upgrade argocd k8s/argocd \
--namespace argocd \
--create-namespace \
--values k8s/argocd/values.yaml \
--set selfapp.enabled="true" \
--set selfapp.deployment="${DEPLOYMENT}" \
--set selfapp.sshkey="$(cat ~/.ssh/github_ed)"

echo "Final sync"
argocd app sync argocd/

