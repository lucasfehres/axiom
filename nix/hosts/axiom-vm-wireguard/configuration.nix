{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-wireguard";
  host.ipv4 = "10.67.1.102";
}
