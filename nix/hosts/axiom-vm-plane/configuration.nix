{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-plane";
  axiom.host.ipv4 = lib.mkDefault "10.67.1.108";
  axiom.host.prompt-color = "xterm_orangered1"; # TODO: change this to some other color

  axiom.host.storage-constrained = true;

  virtualisation.docker.enable = true; # running the docker compose version of Plane
}
