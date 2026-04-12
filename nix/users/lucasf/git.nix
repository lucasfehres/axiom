{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user.name = "Lucas Fehres";
      user.email = "lucasfehres@gmail.com";
      user.signingkey = "8F6F0936E39D9D0E";

      init.defaultbranch = "main";
      commit.gpgsign = "true";
      tag.gpgSign = "true";
    };
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        trust = 5;
        source = ./pgp.pub;
      }
    ];

    scdaemonSettings = {
      # pcsc-driver = "/usr/lib/libpcsclite.so.1";
      card-timeout = "5";
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableNushellIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
