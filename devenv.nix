{ pkgs, ... }:

{
  packages = [ 
    pkgs.git
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.argocd
  ];

  languages.nix.enable = true;
  pre-commit.hooks.shellcheck.enable = true;
}
