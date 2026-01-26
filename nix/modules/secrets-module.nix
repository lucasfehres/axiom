{ lib, config, ... }:
let
  cfg = config.axiom.secrets;
in
{
  options.axiom.secrets.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable encrypted Axiom secrets";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.axiom-primary-wireguard-priv = {
      file = ../secrets/axiom-primary-wireguard-priv.key.age;
      mode = "640";
      owner = "systemd-network";
      group = "systemd-network";
    };

    age.secrets.k3s-token.file = ../secrets/k3s-token.txt.age;
  };
}
