{
  lib,
  ...
}:

{
  networking.hostName = "axiom-vm-k8s-agent-1";
  axiom.host.ipv4 = lib.mkDefault "10.67.1.105";
  axiom.host.prompt-color = "blue";

  axiom.host.storage-constrained = true;

  axiom.host.hetzner-vswitch-ip = "10.69.1.5";
}
