{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-utility";
  host.ipv4 = "10.67.1.104";

  environment.systemPackages = [
    pkgs.kubectl
    pkgs.cilium-cli
    pkgs.velero
    pkgs.vim
  ];
}
