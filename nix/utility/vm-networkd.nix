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

    address = [ "${config.axiom.host.ipv4}/24" ];
    gateway = [ "10.67.1.1" ];
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    routes = lib.optionals (config.networking.hostName != "axiom-vm-wireguard") [
      {
        # axiom-vm-wireguard
        Gateway = "10.67.1.102";
        Destination = "192.168.0.0/16";
      }
    ]
    ++ lib.optionals (config.networking.hostName == "axiom-vm-wireguard") [
      {
        # Make the K8s Cilium pool available over the WireGuard router
        Gateway = "10.67.1.103";
        Destination = "10.67.3.0/24";
      }
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
