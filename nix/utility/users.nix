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

  security.sudo.wheelNeedsPassword = false;
}
