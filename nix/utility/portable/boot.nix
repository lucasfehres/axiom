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
    boot = {
      plymouth = {
        enable = true;
        theme = "spinner";
      };

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];

      loader.systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };

      initrd = {
        availableKernelModules = [ "zfs" ];
        systemd.emergencyAccess = hostCfg.unsafe-debug;
      };
    };

    # important note for later me: set mountpoint to LEGACY in ZFS! won't boot otherwise
    fileSystems."/"     = { device = "zpool/root"; fsType = "zfs"; };
    fileSystems."/nix"  = { device = "zpool/nix";  fsType = "zfs"; };
    fileSystems."/var"  = { device = "zpool/var";  fsType = "zfs"; };
    fileSystems."/home" = { device = "zpool/home"; fsType = "zfs"; };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/${hostCfg.boot-drive-uuid}";
      fsType = "vfat";
      options = if hostCfg.root-only-boot-dir then [ "fmask=0077" "dmask=0077"] else [ "fmask=0022" "dmask=0022"];
    };
  };
}
