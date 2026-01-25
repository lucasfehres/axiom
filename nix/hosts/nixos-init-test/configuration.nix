{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixos-init-test";
  host.ipv4 = "10.67.1.101";
}
