{
  config,
  lib,
  pkgs,
  disko,
  ...
}:

{
  imports = [
    disko.nixosModules.disko
  ];

  # fileSystems."/" =
  #   { device = "/dev/disk/by-label/root";
  #     fsType = "ext4";
  #   };

  swapDevices = [ ];

  disko.devices = {
    disk = {
      main = {
        # When using disko-install, we will overwrite this value from the commandline
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            MBR = {
              type = "EF02";
              size = "1M";
              priority = 1;
            };
            BOOT = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "fat32";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
