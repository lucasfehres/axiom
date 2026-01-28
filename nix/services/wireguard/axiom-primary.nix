{ config, ... }:
{
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "ens18";
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall.checkReversePath = false;

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";

      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };

      address = [
        "10.67.2.1/24"
      ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;

        # ensure file is readable by `systemd-network` user
        PrivateKeyFile = config.age.secrets.axiom-primary-wireguard-priv.path;

        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = "main";
      };
      wireguardPeers = [
        {
          # usg
          PublicKey = "ujqoaf2NnGWXmDyfGkRHXcbIGFczuPSbAM57R8u/ayE=";
          AllowedIPs = [
            "10.67.2.2/32"
            "192.168.0.0/16"
          ];
        }
      ];
    };
  };
}
