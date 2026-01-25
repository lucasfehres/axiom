{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  environment.systemPackages = [
    pkgs.git
    pkgs.openssh
    pkgs.bash
    pkgs.util-linux
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.qemuGuest.enable = true;

  # get DHCP for the installation environment
  # DHCP ranges from 10.67.1.10 to 10.67.1.100
  systemd.network.enable = true;
  systemd.network.networks."10-ether" = {
    matchConfig.Type = "ether";
    networkConfig.DHCP = "ipv4";
  };
  networking.useNetworkd = true;

  environment.etc = {
    "axiom-env-tag" = {
      text = "nix-init-image";
    };
    "axiom-init.sh" = {
      text = ''
        #!/usr/bin/env bash

        set -euxo pipefail

        mkdir /tmp/cloud-init-mnt
        mount /dev/sr0 /tmp/cloud-init-mnt

        git clone https://github.com/lucasfehres/axiom.git /tmp/etc/axiom

        # disko-install doesn't work if the flake isn't in the root of the git tree.
        # so this gets rid of the git tree.
        rm -rf /tmp/etc/axiom/.git

        HOSTNAME="$(grep -E '^hostname:' "/tmp/cloud-init-mnt/user-data" | awk '{print $2}')"

        nix run github:nix-community/disko/latest -- --yes-wipe-all-disks --mode destroy,format,mount --flake /tmp/etc/axiom/nix#"$HOSTNAME"

        nixos-install --flake /tmp/etc/axiom/nix#"$HOSTNAME" --no-root-password

        reboot now
      '';
      mode = "0777";
    };
  };

  systemd.services.axiom-init = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [
      pkgs.git
      pkgs.nix
      pkgs.nixos-install
      pkgs.util-linux
      pkgs.gawk
      pkgs.bash
      "/run/wrappers/bin"
      "/run/current-system/sw/bin"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/etc/axiom-init.sh";
    };
  };
}
