{ pkgs, lib, osConfig }:
let devCfg = osConfig.axiom.dev;
{
  config = lib.mkIf devCfg.enable {
    home.packages = with pkgs.jetbrains [ gateway ]
      ++ lib.optionals devCfg.java [ idea ]
      ++ lib.optionals devCfg.rust [ rust-rover ];
  };
}
