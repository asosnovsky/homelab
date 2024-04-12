# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Bootloader.
  networking.networkmanager.enable = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  networking.firewall.enable = false;
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "01:30" ];
}
