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
