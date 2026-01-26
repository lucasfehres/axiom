{ config, ... }:
{
  imports = [
    ./k3s-common.nix
  ];

  services.k3s.role = "agent";
  services.k3s.serverAddr = "https://10.67.1.103:6443"
}
