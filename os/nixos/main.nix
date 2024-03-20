{ 
  hostName, 
  stateVersion, 
  dbConnectionStr,
  K3SToken
  additionalPkgs = [],
}:
{ config, pkgs, ... }:
{
  imports =
    [ 
      (import ./k3s.nix {
        hostName = hostName;
        dbConnectionStr = dbConnectionStr;
        K3SToken = K3SToken;
        additionalPkgs = additionalPkgs;
      })
      ./users.nix
      ./settings.nix
    ];

  # Bootloader.
  networking.hostName = hostName;
  system.stateVersion = stateVersion;
}
