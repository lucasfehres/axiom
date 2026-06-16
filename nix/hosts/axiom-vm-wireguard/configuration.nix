{ config, lib, pkgs, ... }:

{
  networking.hostName = "axiom-vm-wireguard";
  axiom.host.ipv4 = "10.67.1.102";
  axiom.host.prompt-color = "red";

  # inode exhaustion is a problem on this host due to the 10GB disk.
  # if the nixos-system-upgrade logs say that it can't create a temporary folder check `df -i` for inode counts
  axiom.host.storage-constrained = true;
}
