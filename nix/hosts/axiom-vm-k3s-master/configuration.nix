{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-k3s-master";
  host.ipv4 = "10.67.1.103";
}
