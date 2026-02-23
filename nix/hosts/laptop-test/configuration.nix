{ config, lib, pkgs, ... }:

{
  networking.hostName = "laptop-test";
  axiom.host.portable = true;
  axiom.host.gui = true;
}
