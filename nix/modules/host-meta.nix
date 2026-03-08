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
    types = lib.types.bool;
    default = false;
    description = "Sets configuration options for storage constrained hosts";
  };
}
