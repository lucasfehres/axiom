{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.axiom.openssh;
in
{
  options.axiom.openssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable default OpenSSH configuration";
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.PermitRootLogin = "no";
    services.openssh.startWhenNeeded = true;
  };
}
