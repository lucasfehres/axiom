{ pkgs, ... }:
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

      $env.PROMPT_COMMAND = {
        let host = (sys host | get hostname)
        let pwd = (pwd)

        $"($host) ($pwd) "
      }

      def unfuck-gpg [] {
        gpgconf --kill gpg-agent
        sudo systemctl restart pcscd
      }

      def unfuck-pgp [] {
        unfuck-gpg
      }
    '';
  };

  programs.vim = {
      enable = true;
  };
}
