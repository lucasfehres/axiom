let
  lucasf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADrfGE05Zd40h0IoIsXaewcD1AWNPd12AhJG6h9c8N0 lucasf";
  nixos-init-test = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWrKft1r1LohZt20beWxPhjlkhVTC37TMBZ3ktTG94P root@nixos-init-test";
  axiom-vm-wireguard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxKUS405qW1bI+JxT+xcHQayNqaCG02uffozmX56+vJ root@axiom-vm-wireguard";
  axiom-vm-k3s-master = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN//e1rKxMPXunyccEaIBLTVA2FwdCwwE2lxsy55oLcN root@axiom-vm-k3s-master";
  axiom-vm-k8s-agent-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKW+j547j+6xNnMo8hBVti7ozgtSA9DCHDsgQ+E2ocW root@axiom-vm-k8s-agent-1";
  axiom-vm-gitlab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVU8ZXTPai8iJYhkeam8OpeXYjFn0MT0fd5Sqz+fVnS root@axiom-vm-gitlab";
  pgp-authentication = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxpkLVz4yvM7io7W+4Xo7Y86hD1srAdR9nHF1NIoMU8 openpgp:0x4C2F50F4";
in
{
  "secret.txt.age".publicKeys = [ lucasf pgp-authentication ];
  "axiom-primary-wireguard-priv.key.age".publicKeys = [
    lucasf
    axiom-vm-wireguard
    pgp-authentication
  ];
  "k3s-token.txt.age".publicKeys = [
    lucasf
    axiom-vm-k3s-master
    axiom-vm-k8s-agent-1
    pgp-authentication
  ];
  "pgp-sign-key.age".publicKeys = [ lucasf pgp-authentication ];
  "axiom-harbor-k8s-registries.age".publicKeys = [ lucasf pgp-authentication axiom-vm-k3s-master axiom-vm-k8s-agent-1 ];
  "axiom-rke2-cilium.yaml.age".publicKeys = [ lucasf pgp-authentication axiom-vm-k3s-master axiom-vm-k8s-agent-1 ];

  "axiom-gitlab-db-password.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-initial-password.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-secret-activeRecordDeterministicKey.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-secret-activeRecordPrimaryKey.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-secret-activeRecordSalt.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-secret-db.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-secret-jws.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-secret-otp.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
  "axiom-gitlab-secret-secret.age".publicKeys = [ lucasf pgp-authentication axiom-vm-gitlab ];
}
