{ osConfig, config, pkgs, lib, ... }:
let
  hostCfg = osConfig.axiom.host;
  personalCfg = osConfig.axiom.personal;
  generalCfg = osConfig.axiom.general;
in
{
  config = lib.mkIf personalCfg.enable (lib.mkMerge [
    (lib.mkIf (hostCfg.gui && generalCfg.email) {
      programs.thunderbird = {
        enable = true;
        languagePacks = ["en-GB" "nl"];

        profiles.lucasf = {
          isDefault = true;
          settings = {
            "mail.threadpane.listview" = 1;
            "calendar.week.start" = 1;
          };
        };
      };
    })

    (lib.mkIf (hostCfg.gui && generalCfg.calendar) {
      accounts.calendar.basePath = ".calendar";
    })

    (lib.mkIf (hostCfg.gui && personalCfg.personal-calendar) {
      accounts.calendar.accounts.lucasf-icloud = {
        primary = true;
        remote = {
          type = "caldav";
          url = "https://caldav.icloud.com/";
          userName = "lucasfehres@icloud.com";
          # gets it from Bitwarden, may trigger pinentry
          passwordCommand = ["rbw" "get" "Apple Axiom app specific password"];
        };

        thunderbird = {
          enable = true;
        };
      };

      accounts.calendar.accounts.lucasf-gcal = {
        remote = {
          type = "google_calendar";
          userName = "lucasfehres@gmail.com";
        };

        local.type = "filesystem";
        vdirsyncer = {
          enable = true;
          clientIdCommand     = [ "rbw" "get" "Google Cloud Axiom" "--field=client_id" ];
          clientSecretCommand = [ "rbw" "get" "Google Cloud Axiom" "--field=client_secret" ];
          tokenFile = "${config.xdg.configHome}/vdirsyncer/gcal_token";
          collections = [ "from remote" ];
          conflictResolution = "remote wins";
        };

        # thunderbird = {
        #   enable = true;
        # };
      };
    })
  ]);
}
