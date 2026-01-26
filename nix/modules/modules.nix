{ lib, config, ... }:
{
  imports = [
    ./host-meta.nix
    ./secrets-module.nix
  ];
}
