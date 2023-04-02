#!/bin/bash
set -e

full_path=${1}
app=$(basename $full_path)
location=$(dirname $full_path)
typeofapp=$(basename $location)

mkdir -p $full_path/templates
touch $full_path/values.yaml
touch $full_path/values-{dev,prod}.yaml
cat <<EOT >> $full_path/Chart.yaml
apiVersion: v2
name: $app
description: An $typeofapp service for homelab
type: application
version: 0.1.0
dependencies: []
EOT