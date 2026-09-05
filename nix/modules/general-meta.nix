{ lib, config, ... }:
{
  options.axiom.general.email = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.personal.enable || config.axiom.work.corporate;
  };

  options.axiom.general.calendar = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.personal.enable || config.axiom.work.corporate;
  };
}
