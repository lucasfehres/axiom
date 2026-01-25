{ ... }:
{
  age.secrets.axiom-primary-wireguard-priv = {
    file = ../secrets/axiom-primary-wireguard-priv.key.age;
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };
}
