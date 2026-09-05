{ osConfig, pkgs, lib, ... }:
{
  config = lib.mkIf osConfig.axiom.personal.bitwarden {
    programs.rbw = {
      enable = true;
      settings = {
        # times out after 12 hours, it's not great but a lot depends on this and I don't want to enter it every hour
        sync_interval = 3600 * 12;
        base_url = "https://bitwarden.axiom.lucasfehres.nl";
        email = "lucasfehres@gmail.com";
        pinentry = pkgs.pinentry-qt;
      };
    };
  };
}
