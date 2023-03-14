#!/bin/bash
set -e

full_path=${1}
deployment=${2:-dev}
app=$(basename $full_path)
location=$(dirname $full_path)
tmp_path=$(realpath ".tmp/$location/$deployment-$app.yaml")
echo "writing $location/$app to $tmp_path"

mkdir -p $(dirname $tmp_path)

pushd $full_path
helm dependency update
helm upgrade $app . --namespace $app \
    --debug \
    --values values.yaml \
    --values values-$deployment.yaml \
    > $tmp_path