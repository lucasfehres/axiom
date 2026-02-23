{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.axiom.monitoring.systemd;
in
{
  options.axiom.monitoring.systemd.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable systemd Prometheus exporter";
  };

  config = lib.mkIf cfg.enable {
    services.prometheus.exporters.systemd = {
      # runs on port 9558
      enable = true;
      openFirewall = true;
      listenAddress = config.axiom.monitoring.listen-addr;

      extraFlags = [ "--systemd.collector.enable-resolved" ];
    };
  };
}
