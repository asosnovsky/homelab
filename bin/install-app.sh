#!/usr/bin/env bash
mkdir -p .tmp

deployment=${1:-dev}
keep_old=${2:-no}
keep_old=$(echo "${keep_old:0:1}" | tr '[:upper:]' '[:lower:]')
app=argocd
location=k8s/$app
full_path=$(realpath $location)
tmp_path=".tmp/$location/$deployment-$app.yaml"
mkdir -p $(dirname $tmp_path)

pushd $full_path &> /dev/null
helm dependency update &> /dev/null
popd &> /dev/null

if [ -f "$tmp_path" ]; then
    echo "Found existing file"
    if [[ -f "$tmp_path".old && "${keep_old:0:1}" == "y"  ]]; then
        num_files=$(ls -1q "${tmp_path}.old"* 2> /dev/null | wc -l | tr -d '[:space:]')
        echo " -> Renaming old file to "$tmp_path".old.${num_files}"
        mv $tmp_path $tmp_path".old.${num_files}"
    else
        rm $tmp_path".old"*
        echo " -> Renaming old file to "$tmp_path".old"
        mv $tmp_path $tmp_path".old"
    fi
fi
helm template $app $full_path --namespace $app \
--debug \
--create-namespace \
--values k8s/argocd/values.yaml \
--values k8s/argocd/values-${deployment}.yaml \
--set selfapp.deployment="${deployment}" \
--set selfapp.enabled="true" \
--set selfapp.sshkey="$(cat ~/.ssh/id_rsa)" \
> $tmp_path

echo "Wrote Template! --> $tmp_path"
echo "==============="

if [ -f "$tmp_path.old" ]; then
    echo " -> creating diff -- $tmp_path.diff"
    diff -u $tmp_path".old" $tmp_path > "$tmp_path.diff"
fi