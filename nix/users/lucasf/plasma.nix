{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # https://github.com/KDE/plasma-workspace-wallpapers
  # https://invent.kde.org/plasma/breeze/-/tree/master/wallpapers/Next
  wallpaper =
    "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/5120x2880.png";
in
{
  config = lib.mkIf osConfig.axiom.host.gui {
    programs.okular = {
      enable = true;
      general.obeyDrm = false;
      general.zoomMode = "fitWidth";
    };

    programs.konsole = {
      enable = true;
      defaultProfile = "Nu";

      profiles.Nu = {
        command = "${pkgs.nushell}/bin/nu";
        font.name = "Comic Code";
      };
    };

    programs.plasma = {
      enable = true;
      kscreenlocker.appearance.wallpaper = wallpaper;
      workspace.wallpaper = wallpaper;

      session.sessionRestore = {
        restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };

      panels = [
        {
          floating = true;
          widgets = [
            # https://nix-community.github.io/plasma-manager/options.html#opt-programs.plasma.panels._.widgets
            {
              kickoff = {};
            }
            {
              pager = {};
            }
            {
              iconTasks = {
                launchers = [
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.konsole.desktop"
                  "applications:helium.desktop"
                ]
                ++ lib.optionals osConfig.axiom.work.corporate [ "applications:teams-for-linux.desktop" ]
                ++ lib.optionals osConfig.axiom.personal.enable [ "applications:io.github.equicord.equibop.desktop" ];
              };
            }
            {
              panelSpacer = {};
            }
            {
              systemTray = {};
            }
            {
              digitalClock = {
                Appearance = {
                  enabledCalendarPlugins = "holidaysevents";
                  fontWeight = 400;
                  showWeekNumbers = true;
                };
              };
            }
            "org.kde.plasma.showdesktop"
          ];
        }
      ];

      configFile = {
        # Locale config
        plasma-localerc.Formats = {
          LANG = "en_US.UTF-8";
          LC_MEASUREMENT = "nl_NL.UTF-8";
          LC_MONETARY = "nl_NL.UTF-8";
          LC_NUMERIC = "nl_NL.UTF-8";
          LC_PAPER = "nl_NL.UTF-8";
          LC_TELEPHONE = "C";
          LC_TIME = "nl_NL.UTF-8";
        };

        kdeglobals.General.BrowserApplication = "helium.desktop";

        # Virtual desktops
        kwinrc.Desktops.Number = 3;
        kwinrc.Windows.PerOutputVirtualDesktops = true;

        # Notifications
        plasmanotifyrc."Applications/cider".Seen = true;
        # Prevents annoying "1 notification in dnd-mode" when playing Factorio
        plasmanotifyrc."Applications/cider".ShowInHistory = false;
        plasmanotifyrc."Applications/cider".ShowPopupsInDndMode = true;

        # Keyboard config
        kxkbrc.Layout.DisplayNames = ",";
        kxkbrc.Layout.LayoutList = "us,us";
        kxkbrc.Layout.Options = "compose:ralt";
        kxkbrc.Layout.ResetOldOptions = true;
        kxkbrc.Layout.Use = true;
        kxkbrc.Layout.VariantList = "colemak,";
      };
    };
  };
}
