{ osConfig, lib, pkgs, ... }:
let
  equibop-json = builtins.fromJSON(builtins.readFile ./equibop/equibop.json);
  equicord-json = builtins.fromJSON(builtins.readFile ./equibop/equicord.json);
in
{
  # the equibop package is Linux only
  config = lib.mkIf (osConfig.axiom.personal.enable && pkgs.stdenv.isLinux) {
    programs.equibop = {
      enable = true;
      settings = equibop-json;
      equicord.settings = equicord-json;
    };
  };
}
