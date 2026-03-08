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
        wifi.backend = "wpa_supplicant";

        # more modern than wpa_supplicant, but was unreliable on the test laptop. maybe for later
        # wifi.backend = "iwd";

        ethernet.macAddress = "permanent";

        plugins = with pkgs; [
          networkmanager-openvpn
        ];

        dns = "systemd-resolved";
    };

    programs.captive-browser.enable = true;
    programs.captive-browser.interface = config.axiom.host.wlan-interface;

    # DNS
    services.resolved = {
      enable = true;

      # TODO: this beautiful config was made NixOS release 26.05, enable it when it's released (:
      # settings = {
      #   Resolve = {
      #     DNS = "1.1.1.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com 194.242.2.2#dns.mullvad.net 2a07:e340::2#dns.mullvad.net";
      #     Domains = "~.";
      #     DNSSEC = "allow-downgrade";
      #     Cache = "no-negative";
      #     DNSOverTLS = true;

      #     FallbackDNS = "1.1.1.1 1.0.0.1";
      #   };
      # };

      # and then remove this
      dnssec = "allow-downgrade";
      domains = [ "~." ];
      dnsovertls = "true";
      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };

    # also remove this
    networking.nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "2606:4700:4700::1001#cloudflare-dns.com"
      "194.242.2.2#dns.mullvad.net"
      "2a07:e340::2#dns.mullvad.net"
    ];
  };
}
