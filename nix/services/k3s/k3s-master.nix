{ config, ... }:
{
  imports = [
    ./k3s-common.nix
  ];

  services.k3s.role = "server";
  services.k3s.clusterInit = true;
  services.k3s.extraFlags = toString [
    # required for cilium
    "--flannel-backend=none"
    "--disable-network-policy"
    "--disable-kube-proxy"

    "--disable=traefik"
    "--disable=local-storage"
    "--disable=servicelb"
    "--disable=metrics-server"
    "--disable=coredns"
  ];
}
