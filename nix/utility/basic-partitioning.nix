{
  config,
  lib,
  pkgs,
  ...
}:

{
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
            efi = {
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
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
