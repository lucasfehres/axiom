{
  config,
  lib,
  pkgs,
  ...
}:
let
  keplerConfig = pkgs.writeText "kepler-config.yaml" ''
    log:
      level: info
      format: text
    monitor:
      interval: 5s
      staleness: 1000ms
      maxTerminated: 500
      minTerminatedEnergyThreshold: 10
    host:
      procfs: /host/proc
      sysfs: /host/sys
    rapl:
      zones: []
    exporter:
      stdout:
        enabled: false
      prometheus:
        enabled: true
        metricsLevel:
          - node
          - process
    kube:
      enable: false
    web:
      listenAddresses:
        - ":28282"
  '';
in
{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers.kepler = {
    image = "quay.io/sustainable_computing_io/kepler:latest";

    ports = [ "127.0.0.1:28282:28282" ];

    volumes = [
      "/proc:/host/proc:ro"
      "/sys:/host/sys:ro"
      "${keplerConfig}:/etc/kepler/config.yaml:ro"
    ];

    extraOptions = [
      "--privileged"
      "--pid=host"
    ];

    cmd = [
      "--config.file=/etc/kepler/config.yaml"
    ];

    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 28282 ];

  boot.kernelModules = [ "intel_rapl_common" ];
}
