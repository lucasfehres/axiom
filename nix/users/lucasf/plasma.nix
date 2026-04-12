{ pkgs, ... }:
{
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
  };
}
