{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./kepler.nix
    ./fluent-bit.nix
  ];
}
