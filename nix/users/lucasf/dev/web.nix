{ pkgs, lib, osConfig, ... }:
let
  devCfg = osConfig.axiom.dev;
in
{
  config = lib.mkIf devCfg.web {
    programs.bun.enable = true;

    home.packages = with pkgs; [
      nodejs_26
    ];
  };
}
