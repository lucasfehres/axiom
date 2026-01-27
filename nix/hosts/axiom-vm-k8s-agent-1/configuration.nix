{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-k8s-agent-1";
  axiom.host.ipv4 = lib.mkDefault "10.67.1.105";
}
