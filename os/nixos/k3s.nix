# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  hostName,
  dbConnectionStr,
  K3SToken
}:
{ config, pkgs, ... }:

{
  # Bootloader.
  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };
  i18n.defaultLocale = "en_CA.UTF-8";
  services.nfs.server.enable = true;
  services.rpcbind.enable = true;
  environment.systemPackages = with pkgs; [
     k3s
     nfs-utils
     git
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--tls-san"
    hostName
    "--datastore-endpoint" dbConnectionStr
    "--token" K3SToken
  ];
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];
}
