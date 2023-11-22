#!/bin/bash
set -e

full_path=${1}
deployment=${2:-dev}
app=$(basename $full_path)
location=$(dirname $full_path)
tmp_path=".tmp/$location/$deployment-$app.yaml"
chart_checksum_path=".tmp/.checksums/$location/$deployment-$app.chart.yaml.checksum"

echo "Running for $app:$deployment"

mkdir -p $(dirname $tmp_path)

previous_checksum=""
if [ -f "$chart_checksum_path" ]; then
    previous_checksum=$(cat $chart_checksum_path)
else
    mkdir -p $(dirname $chart_checksum_path)
fi
pushd $full_path &> /dev/null
chart_checksum=$(sha256sum Chart.yaml | cut -d ' ' -f 1)
echo "  > Current Chart.yaml checksum: $chart_checksum"
echo "  > Previous Chart.yaml checksum: $previous_checksum"
if [ "$chart_checksum" == "$previous_checksum" ]; then
    echo "  > skipping helm update!"
else
    echo "  > updating dependencies..."
    helm dependency update 
fi
popd &> /dev/null
echo $chart_checksum > $chart_checksum_path

if [ -f "$tmp_path" ]; then
    echo "  > found existing file"
    echo "  > renaming old file to "$tmp_path".old"
    mv $tmp_path $tmp_path".old"
fi

echo "  > running..."

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