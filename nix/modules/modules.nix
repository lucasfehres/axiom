{ lib, config, ... }:
{
  imports = [
    ./host-meta.nix
    ./k8s-meta.nix
    ./secrets-module.nix
  ];
}
