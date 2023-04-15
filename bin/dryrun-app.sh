#!/bin/bash
set -e

full_path=${1}
deployment=${2:-dev}
app=$(basename $full_path)
location=$(dirname $full_path)
tmp_path=".tmp/$location/$deployment-$app.yaml"


mkdir -p $(dirname $tmp_path)

pushd $full_path &> /dev/null
helm dependency update &> /dev/null
popd &> /dev/null

if [ -f "$tmp_path" ]; then
    echo "found existing file"
    echo "renaming old file to "$tmp_path".old"
    mv $tmp_path $tmp_path".old"
fi

echo $extraArgs

helm template $app $full_path --namespace $app \
    --debug \
    --values $full_path/values.yaml \
    --values $full_path/values-$deployment.yaml \
    > $tmp_path

echo "Wrote Template! --> $tmp_path"
echo "==============="

if [ -f "$tmp_path.old" ]; then
    echo " -> creating diff -- $tmp_path.diff"
    diff -u $tmp_path".old" $tmp_path > "$tmp_path.diff"
fi