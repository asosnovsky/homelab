{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    git
    kubectl
    kubernetes-helm
    jsonnet
    jsonnet-language-server
    argocd
    yq
    jq
    python312
    python312Packages.pyyaml
  ];
  shellHook = ''
      echo "$(pwd)"
      export PATH="$(pwd)/bin:$PATH"
    	export PROMPT="🏠> $PROMPT"
    	echo "Welcome to HomeLab!"
  '';
}
