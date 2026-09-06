{ pkgs, lib, osConfig, ... }:
let
  devCfg = osConfig.axiom.dev;
  temurin = pkgs.javaPackages.compiler.temurin-bin;
in
{
  config = lib.mkIf devCfg.java {
    programs.java = {
      enable = true;
      package = temurin.jdk-21;
    };
  };
}
