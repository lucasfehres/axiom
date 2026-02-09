{ config, ... }:
{
    system.autoUpgrade = {
      enable = true;
      flake = "github:lucasfehres/axiom?dir=nix#${config.networking.hostName}";
      flags = [
        "--print-build-logs"
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
}
