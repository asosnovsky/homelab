#!/bin/bash

terraform init

terraform ${@:-apply} -var-file="dev.tfvars"