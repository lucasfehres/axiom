{ config, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  systemd.enableEmergencyMode = config.axiom.host.unsafe-debug;
}
