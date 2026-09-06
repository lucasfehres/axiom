{ lib, config, ... }:
{
  options.axiom.work.corporate = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Install corporate applications";
  };

  options.axiom.work.cloudwise-email = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.work.corporate;
    description = "Enable Cloudwise email";
  };
}
