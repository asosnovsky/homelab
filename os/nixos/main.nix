{ 
  hostName, 
  stateVersion = "23.05", 
  dbConnectionStr,
  K3SToken
}:
{ config, pkgs, ... }:
{
  imports =
    [ 
      (import "./k3s.nix" {
        hostName = hostName;
        dbConnectionStr = dbConnectionStr;
        K3SToken = K3SToken;
      })
      "./users.nix"
      "./settings.nix"
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  networking.hostName = hostName;
  system.stateVersion = stateVersion;
}
