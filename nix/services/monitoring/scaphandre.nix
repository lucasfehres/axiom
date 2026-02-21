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

  # scaphandre is marked broken ):
  # https://github.com/hubblo-org/scaphandre/issues/403
  nixpkgs.config.allowBroken = lib.mkForce true;
}
