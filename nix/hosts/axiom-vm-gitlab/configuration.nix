{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-gitlab";
  axiom.host.ipv4 = lib.mkDefault "10.67.1.107";

  axiom.host.storage-constrained = true;
}
