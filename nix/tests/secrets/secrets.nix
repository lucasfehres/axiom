let
  lucasf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADrfGE05Zd40h0IoIsXaewcD1AWNPd12AhJG6h9c8N0 lucasf";
  dummy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgp95Im831h6lGJw5rkbvRM2MyoON9I6lqq7lWcOC0d dummy-ed25519-key";
in
{
  "secret.txt.age".publicKeys = [ lucasf ];
  "axiom-primary-wireguard-priv.key.age".publicKeys = [
    lucasf
    dummy
  ];
  "k3s-token.txt.age".publicKeys = [
    lucasf
    dummy
  ];
}
