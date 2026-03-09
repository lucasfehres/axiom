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
  config = lib.mkIf hostCfg.portable {
    # Portable devices do not have static IP addresses
    axiom.monitoring.listen-addr = "127.0.0.1";

    # power monitoring
    axiom.monitoring.kepler.enable = true;

    hardware.gpgSmartcards.enable = true;
    services.pcscd.enable = true;
  };
}
