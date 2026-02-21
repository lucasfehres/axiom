{
  config,
  lib,
  pkgs,
  ...
}:

{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers.kepler = {
    image = "quay.io/sustainable_computing_io/kepler:latest";

    ports = [ "192.168.3.2:28282:28282" "127.0.0.1:28282:28282" ];

    volumes = [
      "/proc:/host/proc:ro"
      "/sys:/host/sys:ro"
    ];

    extraOptions = [
      "--privileged"
      "--pid=host"
    ];

    cmd = [
      "--host.procfs=/host/proc"
      "--host.sysfs=/host/sys"
      "--metrics=node"
      "--metrics=process"
      "--kube.enable=false"
      "--exporter.stdout=false"
      "--monitor.max-terminated=500"
      "--web.listen-address=:28282"
    ];

    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 28282 ];

  boot.kernelModules = [ "intel_rapl_common" ];
}
