{ lib, ... }:

{
  options.axiom.personal.local-pgp = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables local PGP secret activation. Only use on machines authorized to store PGP secrets.";
  };
}
