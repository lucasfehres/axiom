{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.axiom.monitoring.fluent-bit;

  priorityMapScript = pkgs.writeText "fluent-bit-priority-map.lua" ''
      local levels = {
        ["0"] = "emergency",
        ["1"] = "alert",
        ["2"] = "critical",
        ["3"] = "error",
        ["4"] = "warning",
        ["5"] = "notice",
        ["6"] = "info",
        ["7"] = "debug",
      }

      function map_priority(tag, timestamp, record)
        local p = record["PRIORITY"]
        if p ~= nil then
          record["level"] = levels[p] or "unknown"
        end
        return 1, timestamp, record
      end
    '';
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
              systemd_filter = "PRIORITY=6";
              read_from_tail = true;
            }
          ];
          filters = [
            {
              name = "lua";
              match = "*";
              script = "${priorityMapScript}";
              call = "map_priority";
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
