{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-wireguard";
  axiom.host.ipv4 = "10.67.1.102";
}
