{ pkgs, ... }:

{
  packages = [ 
    pkgs.git
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.argocd
    # pkgs.terraform
  ];

  languages.nix.enable = true;
  languages.terraform.enable = true;
  languages.python.enable = true;
  languages.python.venv.enable = true;
  languages.python.venv.requirements = ./pydeps.requirements;
  pre-commit.hooks.shellcheck.enable = true;
}
