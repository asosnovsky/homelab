# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  users.users.ari = {
    isNormalUser = true;
    description = "Ari";
    extraGroups = [ "networkmanager" "wheel" "root" ];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
     pciutils
     usbutils
     jq
  ];

}
