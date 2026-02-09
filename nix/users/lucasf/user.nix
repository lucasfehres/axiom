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
    ];
  };

  home-manager.users.lucasf = { pkgs, ... }: {
    home.username = "lucasf";
    home.homeDirectory = "/home/lucasf";

    home.packages = [
    ];
    programs.bash.enable = true;

    programs.git = {
      enable = true;
      settings.user.name = "Lucas Fehres";
      settings.user.email = "180476097+lucasfehres@users.noreply.github.com";
    };

    programs.nushell = {
        enable = true;
        shellAliases = {
            kube-busybox = "kubectl run -i --rm -t busybox --image=busybox --restart=Never";
            kube-hubble = "kubectl port-forward -n kube-system service/hubble-ui --address 0.0.0.0 8080:80";
        };

        configFile.text = ''
            $env.EDITOR = "vim"

            $env.PROMPT_COMMAND = {
                let host = (sys host | get hostname)
                let pwd = (pwd)

                $"($host) ($pwd) "
            }
        '';
    };

    programs.vim = {
        enable = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.11";
  };
}
