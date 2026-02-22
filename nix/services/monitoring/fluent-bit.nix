{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.axiom.monitoring.fluent-bit;

  logMapScript = pkgs.writeText "fluent-bit-log-map.lua" ''
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

      function normalize_unit(unit)
        if unit == nil then return "unknown" end

        -- sshd@8-118634-10.67.1.103:22-10.67.1.102:42944.service -> sshd@[session].service
        local s = unit:match("^(sshd)@.+%.service$")
        if s then return "sshd@[session].service" end

        -- session-14.scope -> session-[id].scope
        if unit:match("^session%-%d+%.scope$") then
          return "session-[id].scope"
        end

        return unit
      end

      function map_log(tag, timestamp, record)
        local p = record["PRIORITY"]
        if p ~= nil then
          record["level"] = levels[p] or "unknown"
        end

        record["_SYSTEMD_UNIT"] = normalize_unit(record["_SYSTEMD_UNIT"])

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
              script = "${logMapScript}";
              call = "map_log";
            }
          ];
          outputs = [
            {
              name = "loki";
              match = "*";
              labels = "job=nix-fluentbit, host=${config.networking.hostName}, unit=$_SYSTEMD_UNIT, priority=$PRIORITY, level=$level";

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
