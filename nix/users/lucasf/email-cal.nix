{ osConfig, config, pkgs, lib, ... }:
let
  hostCfg = osConfig.axiom.host;
  workCfg = osConfig.axiom.work;
  personalCfg = osConfig.axiom.personal;
  generalCfg = osConfig.axiom.general;
in
{
  config = lib.mkIf (personalCfg.enable || workCfg.corporate) (lib.mkMerge [
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

    (lib.mkIf (hostCfg.gui && workCfg.cloudwise-email) {
      accounts.email.accounts.lucasf-cloudwise = {
        primary = generalCfg.email-primary == "lucasf-cloudwise";
        name = "lucasf-cloudwise";
        realName = "Lucas Fehres";
        userName = "l.fehres@cloudwise.nl";
        address = "l.fehres@cloudwise.nl";

        thunderbird.enable = true;

        imap = {
          tls.enable = true;
          host = "davmail-access.internal.axiom.lucasfehres.nl";
          port = 1143;
          authentication = "plain";
        };

        smtp = {
          tls.enable = true;
          host = "davmail-access.internal.axiom.lucasfehres.nl";
          port = 1025;
          authentication = "plain";
        };
      };
    })

    (lib.mkIf (hostCfg.gui && generalCfg.calendar) {
      accounts.calendar.basePath = ".calendar";
    })

    (lib.mkIf (hostCfg.gui && personalCfg.personal-calendar) {
      accounts.calendar.accounts.lucasf-icloud = {
        primary = generalCfg.email-primary == "lucasf-icloud";
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
        primary = generalCfg.email-primary == "lucasf-gcal";
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
