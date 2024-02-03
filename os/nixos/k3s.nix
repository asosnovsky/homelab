# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
     pkgs.k3s
     nfs-utils
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--tls-san"
    "192.168.0.26"
    "--datastore-endpoint" "postgres://postgres:3wtvrd5KdQYUXE@192.168.0.28:5432/k3sdb?sslmode=disable"
    "--token" "Upi+DZa++9DiAc1po4LkPKPx6Ed1IRrg1VRsglGjp2ERhOssDXaKCWLY8Enk3GIOGyWHHlHKz1dIofXpgkRV2w=="
  ];
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];
}
