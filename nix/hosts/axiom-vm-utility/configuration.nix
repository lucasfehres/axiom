{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-utility";
  axiom.host.ipv4 = lib.mkDefault "10.67.1.104";

  environment.systemPackages = [
    pkgs.kubectl
    pkgs.cilium-cli
    pkgs.velero
    pkgs.vim
  ];
}
