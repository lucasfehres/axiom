{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.axiom.monitoring.kepler;
in
{
  options.axiom.monitoring.fluent-bit.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Fluent Bit log shipping";
  };

  config = lib.mkIf cfg.enable {
    services.fluent-bit = {
      enable = true;
      settings = {
        pipeline = {
          inputs = [
            {
              name = "systemd";
              # everything except debug
              systemd_filter = "PRIORITY<=6";
              read_from_tail = true;
            }
          ];
          outputs = [
            {
              name = "loki";
              match = "*";
              labels = "job=nix-fluentbit, host=${config.networking.hostName}, unit=$_SYSTEMD_UNIT, priority=$PRIORITY";

              host = "loki-write.internal.axiom.lucasfehres.nl";
              port = 443;
              tls = "on";
            }
          ];
        };
        service = {
          grace = 30;
        };
      };
    };
  };
}
