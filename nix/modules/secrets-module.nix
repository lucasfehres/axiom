{ lib, config, ... }:
let
  cfg = config.axiom.secrets;
  hostname = config.networking.hostName;

  # prevents agenix errors when rebuilding
  hasWireguard = builtins.elem hostname [ "axiom-vm-wireguard" ];
  hasK3s = builtins.elem hostname [ "axiom-vm-k3s-master" ];
in
{
  options.axiom.secrets.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable encrypted Axiom secrets";
  };

  config = lib.mkIf cfg.enable {
    age.secrets = lib.mkMerge [
      (lib.mkIf hasWireguard {
        axiom-primary-wireguard-priv = {
          file = ../secrets/axiom-primary-wireguard-priv.key.age;
          mode = "640";
          owner = "systemd-network";
          group = "systemd-network";
        };
      })

      (lib.mkIf hasK3s {
        k3s-token.file = ../secrets/k3s-token.txt.age;
      })
    ];
  };
}
