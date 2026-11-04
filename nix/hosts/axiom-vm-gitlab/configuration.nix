{
  lib,
  ...
}:

{
  networking.hostName = "axiom-vm-gitlab";
  axiom.host.ipv4 = lib.mkDefault "10.67.1.107";
  axiom.host.prompt-color = "xterm_orangered1";

  axiom.host.storage-constrained = true;

  axiom.host.hetzner-vswitch-ip = "10.69.1.3";
}
