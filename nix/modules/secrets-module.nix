{ ... }:
{
  age.secrets.axiom-primary-wireguard-priv = {
    file = ../secrets/axiom-primary-wireguard-priv.key.age;
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  age.secrets.k3s-token.file = ../secrets/k3s-token.txt.age;
}
