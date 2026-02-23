{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostCfg = config.axiom.host;
in
{
  config = lib.mkIf hostCfg.portable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.memtest86.enable = true;
  };

  fileSystems."/"     = { device = "zpool/root"; fsType = "zfs"; };
  fileSystems."/nix"  = { device = "zpool/nix";  fsType = "zfs"; };
  fileSystems."/var"  = { device = "zpool/var";  fsType = "zfs"; };
  fileSystems."/home" = { device = "zpool/home"; fsType = "zfs"; };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AB64-415C";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022"];
  };
}
