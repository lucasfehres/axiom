{
  config,
  lib,
  pkgs,
  ...
}:

{
  systemd.network.enable = true;
  networking.useNetworkd = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
