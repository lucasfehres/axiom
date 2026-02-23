{ config, lib, pkgs, ... }:

{
  networking.hostName = "laptop-test";
  axiom.host.portable = true;
  axiom.host.gui = true;
  axiom.host.wlan-interface = "wlo1";

  # required for ZFS
  networking.hostId = "dead2bad";

  # drivers
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6"; # not sure about this one
  hardware.enableRedistributableFirmware = true;

  # this is an old NixOS install that was moved to this flake
  system.stateVersion = lib.mkForce "24.05";
}
