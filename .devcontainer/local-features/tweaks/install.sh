#!/bin/bash
set -e


USERNAME="${USERNAME:-"${_REMOTE_USER}"}"

cat >> /home/${USERNAME}/.zshrc <<- EOM
source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k
source <(k3d completion zsh)
source <(helm completion zsh)
source <(argocd completion zsh)
EOM

