{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-k3s-master";
  host.ipv4 = "10.67.1.103";

  environment.systemPackages = [
    pkgs.kubectl
    pkgs.cilium-cli
    pkgs.velero
    pkgs.vim
  ];
}
