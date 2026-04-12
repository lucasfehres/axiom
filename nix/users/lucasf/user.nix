{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.lucasf = {
    isNormalUser = true;
    shell = pkgs.nushell;

    extraGroups = [ "wheel" ]
      # WiFi configuration
      ++ lib.optionals (config.axiom.host.portable) [ "networkmanager" ]
      # GUI specific groups
      ++ lib.optionals (config.axiom.host.gui) [ "wireshark" ];

    packages = with pkgs; []
      ++ lib.optionals (config.axiom.host.gui) [ nur.repos.Ev357.helium ];

    openssh.authorizedKeys.keys = [
      # main
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADrfGE05Zd40h0IoIsXaewcD1AWNPd12AhJG6h9c8N0 lucasf"
      # iPhone Axiom Termius
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJ1DvFTPFiuBAVoq5YXckfcpVyefM1X0+Cn386WQA9N2cU69jUNd9ACXW7Y+X+bfkVs+FWNfcM4Zp1nyUjEAeco="
      # iPhone FIDO Yubikey Termius
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBGNjljk8LEZ3fHEHUsZNEytQ4sBIbC9U3FII+Ffp2XPFcv3ZpY2a8KGyLklJaogb8GiG8/ef/0yNIE7T/BY7LtcAAAALdGVybWl1cy5jb20="
      # Macbook Air Axiom Secretive
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL9lvfS3kEC4YjMxjkb8CgM5qf7LKSP52YHE4JS21SOmeIA6EkaPT/Uld9+VOrmfefEKPUy9l32NtbfywcDmz5c="
      # Macbook Air legacy Secretive
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM4PFeUJVWaVQcmUbeo/22FDFRO9/0WYOruBpI0Lr1Q3MchFYKXFwKCfOvavFyGFOUoxa+kabYhbZyrJ+uetZpw="
      # Authentik
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/YxvESiCGKeLy7rJkqbBJE5r9QCE17PR6VINTgna5L authentik"
      # PGP Authentication key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxpkLVz4yvM7io7W+4Xo7Y86hD1srAdR9nHF1NIoMU8 openpgp:0x4C2F50F4"
    ];
  };

  home-manager.users.lucasf = { pkgs, ... }: {
    imports = [
      # make sure to only import home-manager modules!
      ./shell.nix
      ./plasma.nix
      ./git.nix
    ];

    home.username = "lucasf";
    home.homeDirectory = "/home/lucasf";

    home.packages = with pkgs; []
      ++ lib.optionals (config.axiom.host.gui) [ zed-editor ];

    # any personal activation scripts that may have to run
    home.activation = lib.mkMerge [
      (lib.mkIf config.axiom.personal.local-pgp {
        gpg-load-local-pgp-keys = lib.hm.dag.entryAfter ["writeBoundary"] ''
          gpg --import /home/lucasf/.pgp-sign-key
        '';
      })
    ];

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.11";
  };
}
