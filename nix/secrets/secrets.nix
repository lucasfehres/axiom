let
  lucasf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADrfGE05Zd40h0IoIsXaewcD1AWNPd12AhJG6h9c8N0 lucasf";
  nixos-init-test = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWrKft1r1LohZt20beWxPhjlkhVTC37TMBZ3ktTG94P root@nixos-init-test";
  axiom-vm-wireguard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxKUS405qW1bI+JxT+xcHQayNqaCG02uffozmX56+vJ root@axiom-vm-wireguard";
in
{
  "secret.txt.age".publicKeys = [ lucasf ];
  "axiom-primary-wireguard-priv.key.age".publicKeys = [ lucasf axiom-vm-wireguard ];
}
