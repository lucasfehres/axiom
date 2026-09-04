{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.axiom.work.corporate {
    environment.systemPackages = with pkgs; [
      teams-for-linux
    ];
  };
}
