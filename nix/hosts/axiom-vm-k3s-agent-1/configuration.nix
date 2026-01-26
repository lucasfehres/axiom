{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-k3s-agent-1";
  host.ipv4 = "10.67.1.105";
}
