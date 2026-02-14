{
  description = "";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    futils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      futils,
    }:
    (futils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # utilities
            yq
            bat
            jq
            # k8s
            kubectx
            k3d
            (wrapHelm kubernetes-helm {
              plugins = with pkgs.kubernetes-helmPlugins; [
                helm-diff
              ];
            })
            terraform
            argocd
            yq
            jq
            authelia
          ];
          shellHook = ''
            echo "$(pwd)"
            export PATH="$(pwd)/bin:$PATH"
            export PROMPT="🏠| \$(kubectx -c)@\$(kubens -c):📁\$(pwd)> $PROMPT"
            export KUBE_CONFIG_PATH=~/.kube/config
            echo "Welcome to HomeLab!"
          '';
        };
      }
    ));
}
