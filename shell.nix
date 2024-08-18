{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    git
    kubectl
    kubernetes-helm
    argocd
    yq
    jq
    python312
    python312Packages.pyyaml
  ];
}
