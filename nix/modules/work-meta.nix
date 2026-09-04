{ lib, ... }:

{
  options.axiom.work.corporate = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Install corporate applications";
  };
}
