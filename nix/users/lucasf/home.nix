{ config, lib, pkgs, osConfig, ... }:

# shared home-manager configuration for NixOS and nix-darwin hosts,
# the username and home directory are set by the platform specific user files
{
  imports = [
    # make sure to only import home-manager modules!
    ./shell.nix
    ./git.nix
    ./email-cal.nix
    ./secrets.nix
    ./equibop.nix
    ./dev/dev.nix
  ];

  home.packages = with pkgs; []
    ++ lib.optionals (osConfig.axiom.host.gui) [ zed-editor ];

  # any personal activation scripts that may have to run
  home.activation = lib.mkMerge [
    (lib.mkIf osConfig.axiom.personal.local-pgp {
      gpg-load-local-pgp-keys = lib.hm.dag.entryAfter ["writeBoundary"] ''
        gpg --import ${config.home.homeDirectory}/.pgp-sign-key
      '';
    })
  ];

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.11";
}
