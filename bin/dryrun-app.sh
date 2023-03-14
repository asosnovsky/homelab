#!/bin/bash
set -e

full_path=${1}
deployment=${2:-dev}
app=$(basename $full_path)
location=$(dirname $full_path)
tmp_path=".tmp/$location/$deployment-$app.yaml"
argocd_values_path=$(realpath k8s/argocd/values-$deployment.yaml)
echo "> writing $location/$app to $tmp_path"
echo "> using argo values of $argocd_values_path"
cat $argocd_values_path | yq
mkdir -p $(dirname $tmp_path)

pushd $full_path &> /dev/null
helm dependency update &> /dev/null
popd &> /dev/null

helm template $app $full_path --namespace $app \
    --debug \
    --values $argocd_values_path \
    --values $full_path/values.yaml \
    --values $full_path/values-$deployment.yaml \
    > $tmp_path