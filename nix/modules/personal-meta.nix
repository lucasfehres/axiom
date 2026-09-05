{ lib, config, ... }:

{
  options.axiom.personal.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables personal settings and programs";
  };

  options.axiom.personal.local-pgp = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables local PGP secret activation. Only use on machines authorized to store PGP secrets.";
  };

  options.axiom.personal.personal-email = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.personal.enable && config.axiom.general.email;
    description = "Enables personal email accounts";
  };

  options.axiom.personal.personal-calendar = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.personal.enable && config.axiom.general.calendar;
    description = "Enables personal calendar accounts";
  };

  options.axiom.personal.bitwarden = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.personal.enable;
    description = "Enables a configured rbw CLI Bitwarden client, some accounts depend on it";
  };
}
