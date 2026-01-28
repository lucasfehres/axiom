{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.lucasf = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADrfGE05Zd40h0IoIsXaewcD1AWNPd12AhJG6h9c8N0 lucasf"
    ];
  };

  home-manager.users.lucasf = { pkgs, ... }: {
    home.username = "lucasf";
    home.homeDirectory = "/home/lucasf";

    home.packages = [ ];
    programs.bash.enable = true;

    programs.git = {
      enable = true;
      userName = "Lucas Fehres";
      userEmail = "jane.doe@example.org";
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.11";
  };
}
