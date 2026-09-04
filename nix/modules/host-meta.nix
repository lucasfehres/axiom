{ lib, ... }:

{
  options.axiom.host.ipv4 = lib.mkOption {
    type = lib.types.str;
    example = "10.67.1.121";
    description = "Primary IPv4 address. Recommended range is from 10.67.1.101 to 10.67.1.200";
  };

  options.axiom.host.portable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables options specific for portable devices";
  };

  options.axiom.host.boot-drive-uuid = lib.mkOption {
    type = lib.types.str;
    description = "Boot drive UUID. Required for portable devices";
  };

  options.axiom.host.root-only-boot-dir = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Mount /boot with root only access";
  };

  options.axiom.host.unsafe-debug = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables emergency shells. Do not leave enabled";
  };

  options.axiom.host.gui = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the graphical user interface";
  };

  options.axiom.host.wlan-interface = lib.mkOption {
    type = lib.types.str;
    example = "wlo1";
    description = "Configures the default wireless interface";
  };

  options.axiom.host.storage-constrained = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Sets configuration options for storage constrained hosts";
  };

  options.axiom.host.prompt-color = lib.mkOption {
    type = lib.types.str;
    default = "green";
    description = "Configures the Nushell prompt color";
  };

  options.axiom.host.confidential = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Sets to auto update from the axiom-confidental repository";
  };
}
