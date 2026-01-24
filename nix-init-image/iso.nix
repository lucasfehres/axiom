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

  services.cloud-init.enable = true;

  systemd.services.axium-init = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.git pkgs.nix ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        git clone https://github.com/lucasfehres/axium.git /mnt/etc/axium

        HOSTNAME="$(cat /mnt/etc/hostname)"
        nixos-install --flake /mnt/etc/axium/nix#"$HOSTNAME"
      '';
    };
  };
}
