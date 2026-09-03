{ config, lib, pkgs, ... }:

{
  networking.hostName = "cloudwise-laptop";
  axiom.host.portable = true;
  axiom.host.gui = true;
  axiom.host.wlan-interface = "wlo1";

  # required for ZFS
  networking.hostId = "67676767";

  # drivers
  hardware.enableRedistributableFirmware = true;
}
