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
      settings.user.name = "Lucas Fehres";
      settings.user.email = "jane.doe@example.org";
    };

    programs.nushell = {
        enable = true;
        shellAliases = {
            kube-busybox = "kubectl run -i --rm -t busybox --image=busybox --restart=Never";
            kube-hubble = "kubectl port-forward -n kube-system service/hubble-ui --address 0.0.0.0 8080:80";
        };
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.11";
  };
}
