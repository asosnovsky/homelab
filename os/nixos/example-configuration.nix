{ ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      (import ./main.nix {
        hostName = "";
        stateVersion = "23.05"; 
        dbConnectionStr = "";
        K3SToken = "";
      })
    ];
}