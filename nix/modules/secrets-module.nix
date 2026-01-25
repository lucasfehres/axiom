{ ... }:
{
  age.secrets.axiom-primary-wireguard-priv = {
    file = ../secrets/axiom-primary-wireguard-priv.key.age;
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  age.secrets.axiom-primary-wireguard-peer-m17.file = ../secrets/axiom-primary-wireguard-peer-m17.pub.age;
}
