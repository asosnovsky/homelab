#!/bin/bash

k config use-context k3d-k3s-default 
terraform init
terraform ${@:-apply} -var-file="dev.tfvars"