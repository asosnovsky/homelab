#!/bin/bash

terraform init
export TF_VAR_local_root_storage_path="$(pwd)/.tmp"
mkdir -p $TF_VAR_local_root_storage_path/{postgres}
terraform ${@:-apply} -var-file="dev.tfvars"