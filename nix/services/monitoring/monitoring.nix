{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.axiom.monitoring.listen-addr = lib.mkOption {
      type = lib.types.str;
      default = config.axiom.host.ipv4;
      description = "Listening address for monitoring";
  };

  imports = [
    ./kepler.nix
    ./fluent-bit.nix
    ./systemd.nix
  ];
}
