{ config, ... }:
{
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "ens18";
    internalInterfaces = [ "wg0" ];
  };

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";

      networkConfig = {
        # do not use IPMasquerade,
        # unnecessary, causes problems with host ipv6
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };

      address = [
        # /32 and /128 specifies a single address
        # for use on this wg peer machine
        # "fd31:bf08:57cb::7/128"
        "10.67.2.0/24"
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

        # FirewallMark marks all packets send and received by wg0
        # with the number 42, which can be used to define policy rules on these packets.
        #FirewallMark = 42;
      };
      wireguardPeers = [
        {
          # laptop wg conf
          PublicKey = "ujqoaf2NnGWXmDyfGkRHXcbIGFczuPSbAM57R8u/ayE=";
          AllowedIPs = [
            # "fd31:bf08:57cb::9/128"
            "10.67.0.0/16"
          ];
          # Endpoint = "192.168.1.26:51820";

          # RouteTable can also be set in wireguardPeers
          # RouteTable in wireguardConfig will then be ignored.
          # RouteTable = 1000;
        }
      ];
    };
  };
}
