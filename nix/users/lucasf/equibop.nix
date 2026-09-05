{ osConfig, lib, ... }:
let
  equibop-json = builtins.fromJSON(builtins.readFile ./equibop/equibop.json);
  equicord-json = builtins.fromJSON(builtins.readFile ./equibop/equicord.json);
in
{
  config = lib.mkIf osConfig.axiom.personal.enable {
    programs.equibop = {
      enable = true;
      settings = equibop-json;
      equicord.settings = equicord-json;
    };
  };
}
