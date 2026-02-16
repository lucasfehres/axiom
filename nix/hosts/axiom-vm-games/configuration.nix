{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixos-vm-games";
  axiom.host.ipv4 = "10.67.1.106";
}
