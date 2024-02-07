{ 
  hostName, 
  stateVersion, 
  dbConnectionStr,
  K3SToken
}:
{ config, pkgs, ... }:
{
  imports =
    [ 
      (import ./k3s.nix {
        hostName = hostName;
        dbConnectionStr = dbConnectionStr;
        K3SToken = K3SToken;
      })
      ./users.nix
      ./settings.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = hostName;
  system.stateVersion = stateVersion;
}
