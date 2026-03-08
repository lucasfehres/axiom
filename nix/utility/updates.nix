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

    # axiom-vm-wireguard had problems with inode exhaustion due to the nix store
    dates = if config.axiom.host.storage-constrained then "daily" else "weekly";
    options = if config.axiom.host.storage-constrained then "--delete-older-than 7d" else "--delete-older-than 30d";
  };
}
