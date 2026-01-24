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
  services.cloud-init.network.enable = true;

  environment.etc = {
      "axiom-init.sh" = {
            text = ''
                #!/run/current-system/sw/bin/bash

                git clone https://github.com/lucasfehres/axiom.git /mnt/etc/axiom

                HOSTNAME="$(cat /mnt/etc/hostname)"
                nixos-install --flake /mnt/etc/axiom/nix#"$HOSTNAME"
            '';
            mode = "0777";
      };
  };

  systemd.services.axiom-init = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.git pkgs.nix ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/etc/axiom-init.sh";
    };
  };
}
