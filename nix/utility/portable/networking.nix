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
    # WiFi
    networking.networkmanager = {
        enable = true;

        wifi.powersave = true;
        wifi.macAddress = "stable-ssid";
        # more modern than wpa_supplicant, but Intel
        wifi.backend = "iwd";

        ethernet.macAddress = "permanent";

        plugins = with pkgs; [
          networkmanager-openvpn
        ];

        dns = "systemd-resolvd";
    };
  };
}
