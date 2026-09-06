{ lib, config, ... }:
{
  options.axiom.dev.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable development environment";
  };

  options.axiom.dev.rust = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.dev.enable;
    description = "Enable Rust language support";
  };

  options.axiom.dev.java = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.dev.enable;
    description = "Enable Java language support";
  };
}
