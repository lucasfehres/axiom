{ config, ... }:
let
  hostCfg = config.axiom.host;
  gitProtocol = if hostCfg.confidential then "git+ssh://git@github.com/" else "github:";
in
{
  system.autoUpgrade = {
    enable = true;
    flake = "${gitProtocol}lucasfehres/axiom${if hostCfg.confidential then "-confidential" else ""}?dir=nix#${config.networking.hostName}";
    flags = [
      "--print-build-logs"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  nix.gc = {
    automatic = true;

    # axiom-vm-wireguard had problems with inode exhaustion due to the nix store
    dates = if hostCfg.storage-constrained then "daily" else "weekly";
    options = if hostCfg.storage-constrained then "--delete-older-than 7d" else "--delete-older-than 30d";
  };
}
