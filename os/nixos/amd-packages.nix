{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
     rocmPackages.rocm-smi
     rocmPackages.rpp     
  ];
}