{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s api server
    4240 # cilium health monitoring
    2379 # cilium etcd access
    2380 # also cilium etcd access
  ];
  networking.firewall.allowedUDPPorts = [
    51871 # cilium wireguard
  ];

  services.k3s = {
    enable = true;
    tokenFile = config.age.secrets.k3s-token.path;
  };
}
