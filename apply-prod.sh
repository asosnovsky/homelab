#!/bin/bash
set -e 

scp prod.tfvars rancher@MasterNode.lan:~/
kubectl config use-context masternode 
terraform init
terraform ${@:-apply} -var-file="prod.tfvars"