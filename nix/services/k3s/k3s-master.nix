{ config, ... }:
{
  imports = [
    ./k3s-common.nix
  ];

  services.k3s.role = "server";
  services.k3s.clusterInit = true;
}
