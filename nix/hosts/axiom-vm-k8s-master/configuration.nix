{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-k8s-master";
  axiom.host.ipv4 = lib.mkDefault "10.67.1.103";
  axiom.host.prompt-color = "cyan";

  axiom.host.storage-constrained = true;
}
