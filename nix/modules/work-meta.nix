{ lib, config, ... }:
{
  options.axiom.work.corporate = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Install corporate applications";
  };

  options.axiom.work.cloudwise-email = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Cloudwise email";
  };

  options.axiom.work.che-email = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable CHE email";
  };
}
