#!/bin/sh

NS=terraforms
TF_VARS_SECRET=homelab-tfvars
TFVAR_FILE_NAME=var.auto.tfvars.json
LOCAL_TF_VARS=./terraform/$TFVAR_FILE_NAME

save_tfvars() {
    echo "$LOCAL_TF_VARS ... > kubectl -n $NS create secret/$TF_VARS_SECRET"
    kubectl -n $NS create secret generic $TF_VARS_SECRET \
        --save-config \
        --dry-run=client \
        --from-file=var.auto.tfvars.json=$LOCAL_TF_VARS \
        -o yaml | kubectl apply -f -
}

get_tfvars() {
    echo "kubectl -n $NS get secret/$TF_VARS_SECRET ... > $LOCAL_TF_VARS"
    kubectl -n $NS get secret/$TF_VARS_SECRET \
        -o jsonpath="{.data['var\.auto\.tfvars\.json']}" \
        | base64 -d > $LOCAL_TF_VARS
}

plan() {
    pushd ./terraform || exit 1
    terraform plan 
}

apply() {
    pushd ./terraform || exit 1
    save_tfvars
    terraform apply 
}

init() {
    pushd ./terraform || exit 1
    get_tfvars
    terraform init
}
help() {
    echo "My Awesome Terraform Wrapper!"
    echo ""
    echo "  a|apply) apply terraform in ./terraform folder"
    echo "  p|plan) plan terraform in ./terraform folder"
    echo "  i|init) download latest tfvars and init ./terraform folder"
    echo "  s|save-tfvars) save tfvars to k8s ns"
    echo "  g|get-tfvars) downloads tfvars from k8s ns"
    echo "  h|help) display this help"
    echo ""
}
case $1 in 
    a|apply)
        apply
        ;;
    p|plan)
        plan
        ;;
    i|init)
        init
        ;;
    s|save-tfvars)
        save_tfvars
        ;;
    g|get-tfvars)
        get_tfvars
        ;;
    h|help)
        help
        ;;
    *)
        echo "invalid input '$1'!"
        help
        ;;
esac