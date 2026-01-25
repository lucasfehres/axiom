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

  environment.etc = {
      "axiom-init.sh" = {
            text = ''
                #!/run/current-system/sw/bin/bash

                mkdir /mnt/cloud-init-mnt
                mount /dev/sr0 /mnt/cloud-init-mnt

                git clone https://github.com/lucasfehres/axiom.git /mnt/etc/axiom

                HOSTNAME="$(grep -E '^hostname:' "/mnt/cloud-init-mnt/user-data" | awk '{print $2}')"
                nixos-install --flake /mnt/etc/axiom/nix#"$HOSTNAME"
            '';
            mode = "0777";
      };
  };

  systemd.services.axiom-init = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.git pkgs.nix pkgs.nixos-install ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/etc/axiom-init.sh";
    };
  };
}
