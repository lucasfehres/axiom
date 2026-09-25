{ config, lib, pkgs, ... }:

{
  networking.hostName = "br1-mng-laptop";
  axiom.host.portable = true;
  axiom.host.gui = true;
  axiom.host.wlan-interface = "wlo1";
  axiom.host.boot-drive-uuid = "AB64-415C";

  networking.hostId = "12ef12ef";

  # drivers
  # hardware.ipu6.enable = true;
  # hardware.ipu6.platform = "ipu6"; # not sure about this one
  hardware.enableRedistributableFirmware = true;
}
