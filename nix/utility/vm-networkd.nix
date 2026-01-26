{
  config,
  lib,
  pkgs,
  ...
}:

{
  systemd.network.enable = true;
  networking.useNetworkd = true;

  systemd.network.networks."10-ether" = {
    matchConfig.Type = "ether";
    matchConfig.Name = "en* eth*";

    address = [ "${config.host.ipv4}/24" ];
    gateway = [ "10.67.1.1" ];
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  systemd.network.networks."99-cilium-ignore" = {
    matchConfig = {
      Name = "cilium_* lxc*";
    };
    linkConfig = {
      Unmanaged = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [
    # Wireguard server
    51820
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
