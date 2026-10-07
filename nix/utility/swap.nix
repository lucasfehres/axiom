{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostCfg = config.axiom.host;
in
{
  config = lib.mkIf (hostCfg.swap-partition != null) {
    swapDevices = [
      { device = hostCfg.swap-partition; randomEncryption.enable = true; }
    ];
  };
}
