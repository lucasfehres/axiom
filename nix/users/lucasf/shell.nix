{ pkgs, osConfig, ... }:
let
  hostCfg = osConfig.axiom.host;
  isDarwin = pkgs.stdenv.isDarwin;

  # same flake as system.autoUpgrade in utility/updates.nix
  gitProtocol = if hostCfg.confidential then "git+ssh://git@github.com/" else "github:";
  upgradeFlake = "${gitProtocol}lucasfehres/axiom${if hostCfg.confidential then "-confidential" else ""}?dir=nix#${osConfig.networking.hostName}";

  upgradeCommands = if isDarwin then ''
    def axiom-upgrade [] {
      sudo darwin-rebuild switch --flake "${upgradeFlake}"
    }
  '' else ''
    def axiom-upgrade [] {
      sudo systemctl start --no-block nixos-upgrade
      sudo journalctl -fxeu nixos-upgrade -u home-manager-lucasf
    }

    def axiom-upgrade-check [] {
      sudo journalctl -xeu nixos-upgrade -u home-manager-lucasf
    }
  '';
in
{
  programs.bash.enable = true;

  programs.nushell = {
    enable = true;
    shellAliases = {
      kube-busybox = "kubectl run -i --rm -t busybox --image=busybox --restart=Never";
      kube-hubble = "kubectl port-forward -n kube-system service/hubble-ui --address 0.0.0.0 8080:80";
    };

    configFile.text = ''
      $env.EDITOR = "vim"

      # prevents issues with using GPG over a SSH session
      $env.GPG_TTY = (tty)

      $env.PROMPT_COMMAND = {
        let host = (sys host | get hostname)
        let pwd = (pwd)

        $"(ansi ${osConfig.axiom.host.prompt-color})($host) ($pwd)(ansi reset) "
      }

      def unfuck-gpg [] {
        gpgconf --kill gpg-agent
        ${if isDarwin then "" else "sudo systemctl restart pcscd"}
      }

      def unfuck-pgp [] {
        unfuck-gpg
      }

      ${upgradeCommands}

      def axiom-caldav-vdirsyncer-jumpstart [] {
        vdirsyncer discover gcal
        vdirsyncer sync
      }
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.vim = {
    enable = true;
  };
}
