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
      };
    };

    programs.plasma = {
      enable = true;
      kscreenlocker.appearance.wallpaper = wallpaper;
      workspace.wallpaper = wallpaper;

      panels = [
        {
          widgets = [
            # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.panels._.widgets
            {
              kickoff = {
                icon = "start-here-kde-plasma";
              };
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
                ];
              };
            }
            {
              panelSpacer = {};
            }
            {
              systemTray = {};
            }
            {
              digitalClock = {};
            }
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };
  };
}
