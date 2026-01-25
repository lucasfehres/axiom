let
  lucasf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADrfGE05Zd40h0IoIsXaewcD1AWNPd12AhJG6h9c8N0 lucasf";
  nixos-init-test = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkIAy/GCAVgHvEJTJY/4gIETTMxX6hLBEi66gfo7a2u root@nixos-init-test";
in
{
  "secret.txt.age".publicKeys = [ lucasf ];
  "axiom-primary-wireguard-priv.key.age".publicKeys = [ lucasf ];
  "axiom-primary-wireguard-peer-m17.pub.age".publicKeys = [ lucasf ];
}
