{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.prometheus.exporters.scaphandre = {
      enable = true;
      openFirewall = true;
      port = 9176;
  };

  boot.kernelModules = [ "intel_rapl_common" ];
}
