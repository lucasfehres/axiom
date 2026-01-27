{ config, ... }:
{
  systemd.network.enable = true;
  networking.useNetworkd = true;
  networking.dhcpcd.enable = false;
  networking.firewall.allowPing = true;

  systemd.network.networks."99-cilium-ignore" = {
      matchConfig = {
          Name = "cilium_* lxc*";
      };
      linkConfig = {
          Unmanaged = true;
      };
  };

  # boot.kernel.sysctl = {
  #     "net.ipv4.conf.all.rp_filter" = 0;      # or 2 for loose mode
  #     "net.ipv4.conf.default.rp_filter" = 0;  # or 2 for loose mode
  #     # Enable IP forwarding (required for pod networking)
  #     "net.ipv4.ip_forward" = 1;
  #     "net.ipv4.conf.all.forwarding" = 1;
  #   };

  networking.firewall.allowedTCPPorts = [
    6443 # k3s api server
    4240 # cilium health monitoring
    2379 # cilium etcd access
    2380 # also cilium etcd access
  ];
  networking.firewall.allowedUDPPorts = [
    51871 # cilium wireguard
  ];

  # networking.firewall.enable = false;
  networking.firewall.checkReversePath = false;
  networking.firewall.trustedInterfaces = [ "cilium_+" "lxc+" ];

  services.k3s = {
    enable = true;
    tokenFile = config.age.secrets.k3s-token.path;
  };
}
