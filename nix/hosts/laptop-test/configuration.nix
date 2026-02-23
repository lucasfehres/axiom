{ config, lib, pkgs, ... }:

{
  networking.hostName = "laptop-test";
  axiom.host.portable = true;
  axiom.host.gui = true;

  # required for ZFS
  networking.hostId = "dead2bad";

  # this is an old NixOS install that was moved to this flake
  system.stateVersion = lib.mkForce "24.05";
}
