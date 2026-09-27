{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.br1 = {
    isNormalUser = true;
    shell = pkgs.nushell;

    extraGroups = []
      # WiFi configuration
      ++ lib.optionals (config.axiom.host.portable) [ "networkmanager" ];

    packages = with pkgs; []
      ++ lib.optionals (config.axiom.host.gui) [ nur.repos.Ev357.helium ];
  };

  home-manager.users.br1 = { pkgs, ... }: {
    imports = [
      # make sure to only import home-manager modules!
    ];

    home.username = "br1";
    home.homeDirectory = "/home/br1";

    home.packages = with pkgs; [
      prismlauncher
    ];

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.11";
  };
}
