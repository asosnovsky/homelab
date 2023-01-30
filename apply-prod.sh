#!/bin/bash

scp prod.tfvars rancher@MasterNode.lan:~/
k config use-context masternode 
terraform init
terraform ${@:-apply} -var-file="prod.tfvars"