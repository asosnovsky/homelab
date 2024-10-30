#!/bin/sh

## Colors
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'
BLUE_BOLD='\033[1;34m'
YELLOW_BOLD='\033[1;33m'


function list_run_functions() {
    declare -F | awk '$3 ~ /^run-/{sub("run-", "", $3); print $3}'
}

function start_cli() {
    MENAME=$(basename $0)
    all_functions=$(list_run_functions)
    
    for f in ${all_functions[@]}; do
        if [ "$1" == "$f" ]; then
            echo -e "Running ${BLUE_BOLD}$1${NC}"
            run-$1 ${@:2} 2>&1 | sed "s/^/\t│ /"
            ecode=$(echo $?)
            echo -e "\t└──${NC}DONE ${BLUE_BOLD}$1${NC}"
            exit $ecode
        fi
    done
    
    echo -e "Invalid Command '$1' please select one of${NC}"
    for function_name in $all_functions; do
        start_line=$(grep -n -m 1 "function run-$function_name" "${BASH_SOURCE[1]}" | cut -d: -f1)
        end_line=$(awk "NR > $start_line && /^}/ {print NR; exit}" "${BASH_SOURCE[1]}")
        function_body=$(sed -n "${start_line},${end_line}p" "${BASH_SOURCE[1]}")
        description=$(echo "$function_body" | sed -n '/^\s*:/,/^\s*[^:]/p' | sed 's/^\s*:\s*/ │ /')
        echo -e "$BOLD\r$MENAME \`${function_name}\`$NC\n${description}\n └──────────\n"
    done
    
}


function check-deploy-name() {
    deploy=${1}
    if [[ "$deploy" == "prod" || "$deploy" == "dev" ]]; then
        echo "Deploy environment is set to $deploy."
    else
        echo "Invalid deploy environment. Must be 'dev' or 'prod', but got '${deploy}'."
        exit 1
    fi
}

function check-argo-alive() {
    pod_statuses=$(kubectl -n argocd get pod -o json | jq -r '.items[].status.phase')
    
    # Check if all pod statuses are "Running"
    for pod_status in $pod_statuses; do
        if [[ "$status" != "Running" ]]; then
            return 0
        fi
    done
    return 1
}