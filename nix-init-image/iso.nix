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
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # get DHCP for the installation environment
  # DHCP ranges from 10.67.1.10 to 10.67.1.100
  systemd.network.enable = true;
  systemd.network.networks."10-ether" = {
    matchConfig.Type = "ether";
    networkConfig.DHCP = "ipv4";
  };
  networking.useNetworkd = true;

  environment.etc = {
      "axiom-init.sh" = {
            text = ''
                #!/run/current-system/sw/bin/bash

                mkdir /mnt/cloud-init-mnt
                mount /dev/sr0 /mnt/cloud-init-mnt

                git clone https://github.com/lucasfehres/axiom.git /mnt/etc/axiom

                # disko-install doesn't work if the flake isn't in the root of the git tree.
                # so this gets rid of the git tree.
                rm -rf /mnt/etc/axiom/.git

                HOSTNAME="$(grep -E '^hostname:' "/mnt/cloud-init-mnt/user-data" | awk '{print $2}')"
                # nixos-install --flake /mnt/etc/axiom/nix#"$HOSTNAME"
                # Use disko to handle filesystem partitioning
                nix run 'github:nix-community/disko/latest#disko-install' -- --flake /mnt/etc/axiom/nix#"$HOSTNAME" --disk main /dev/sda

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
        "/run/wrappers/bin"
        "/run/current-system/sw/bin"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/etc/axiom-init.sh";
    };
  };
}
