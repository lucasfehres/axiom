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

  options.axiom.monitoring.fluent-bit.node-metrics = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Fluent Bit node metrics input";
  };

  options.axiom.monitoring.fluent-bit.prometheus-exporter = lib.mkOption {
    type = lib.types.bool;
    default = config.axiom.monitoring.fluent-bit.node-metrics;
    description = "Enable Fluent Bit Prometheus exporter output";
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
          ]
          ++ lib.optionals (config.axiom.monitoring.fluent-bit.node-metrics) [
            {
              name = "node_exporter_metrics";
              tag = "prom_node_exporter";
              # everything but uname due to duplicate nodename labels
              metrics = "cpu,cpufreq,meminfo,diskstats,filesystem,stat,time,loadavg,vmstat,netdev,netstat,sockstat,filefd,systemd,nvme,thermal_zone,hwmon";
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
          ]
          ++ lib.optionals (config.axiom.monitoring.fluent-bit.prometheus-exporter) [
            {
              name = "prometheus_exporter";
              match = "prom_*";
              host = config.axiom.host.ipv4;
              port = 2021;
              add_label = [
                # called nodename to match the relabeling in the K8s node exporter
                "nodename ${config.networking.hostName}"
              ];
            }
          ];
        };
        service = {
          grace = 30;
        };
      };
    };

    networking.firewall.allowedTCPPorts = lib.optionals (config.axiom.monitoring.fluent-bit.prometheus-exporter) [
      # Fluent Bit Prometheus exporter port
      2021
    ];
  };
}
