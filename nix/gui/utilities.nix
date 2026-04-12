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
  config = lib.mkIf hostCfg.gui {
    programs.wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
  };
}
