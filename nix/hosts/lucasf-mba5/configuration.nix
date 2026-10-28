{ config, lib, pkgs, ... }:

{
  networking.hostName = "lucasf-mba5";
  networking.computerName = "lucasf-mba5";

  axiom.host.gui = true;
  axiom.host.prompt-color = "cyan";

  axiom.personal.enable = true;
  axiom.dev.enable = true;

  axiom.work.cloudwise-email = true;
  axiom.work.che-email = true;
  axiom.general.email-primary = "lucasf-cloudwise";

  # the Nix installer created the nixbld group with this GID
  ids.gids.nixbld = 30000;
}
