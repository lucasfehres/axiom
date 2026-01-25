{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./general.nix
    ./vm-bootloader.nix
    ./vm-networkd.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
