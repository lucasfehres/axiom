{ config, lib, ... }:
let
  ip = config.axiom.host.hetzner-vswitch-ip;
in
{
  config = lib.mkIf (ip != null) {
    systemd.network.networks."05-vswitch" = {
      matchConfig.Name = "ens19";
      address = [ "${ip}/24" ];
      linkConfig.MTUBytes = 1400;
      routes = [
        {
          Destination = "10.69.0.0/16";
          Gateway = "10.69.1.1";
        }
      ];
    };
  };
}
