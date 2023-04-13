#!/bin/bash
set -e

full_path=${1}
deployment=${2:-dev}
action=${3:-install}
app=$(basename $full_path)
location=$(dirname $full_path)
tmp_path=".tmp/$location/$deployment-$app.yaml"


mkdir -p $(dirname $tmp_path)

pushd $full_path &> /dev/null
helm dependency update &> /dev/null
popd &> /dev/null

extraArgs=""
for f in k8s/argocd/values/shared/*.yaml; do
    full_file_path=$(realpath $f)
    extraArgs=$extraArgs" --values ${full_file_path}"
done
for f in k8s/argocd/values/$deployment/*.yaml; do
    full_file_path=$(realpath $f)
    extraArgs=$extraArgs" --values ${full_file_path}"
done

echo "Installing $app"

helm $action $app $full_path --namespace $app \
    --debug \
    --values $full_path/values.yaml \
    --create-namespace \
    --dependency-update \
    $extraArgs \
    > $tmp_path

