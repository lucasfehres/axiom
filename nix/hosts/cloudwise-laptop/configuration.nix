{ config, lib, pkgs, ... }:

{
  networking.hostName = "cloudwise-laptop";
  axiom.host.portable = true;
  axiom.host.gui = true;
  axiom.host.wlan-interface = "wlo1";
  axiom.host.boot-drive-uuid = "22CE-74BA";
  axiom.host.root-only-boot-dir = true;
  axiom.host.unsafe-debug = false;
  axiom.host.confidential = true;

  axiom.work.corporate = true;
  axiom.work.cloudwise-email = true;
  axiom.personal.bitwarden = true;
  axiom.general.email-primary = "lucasf-cloudwise";

  # required for ZFS
  networking.hostId = "67676767";

  # drivers
  hardware.enableRedistributableFirmware = true;
}
