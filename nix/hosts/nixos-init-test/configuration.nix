{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixos-init-test";
  axiom.host.ipv4 = "10.67.1.101";
}
