{ pkgs, lib, ... }:
{
  axiom.secrets.enable = false;

  system.activationScripts = {
      agenixNewGeneration.deps = lib.mkForce [ "specialfs" "axiom-dummy-ssh-keys" ];
      axiom-dummy-ssh-keys = {
          deps = [];
          text = ''
              mkdir -p /etc/ssh
              cat << EOF > /etc/ssh/ssh_host_ed25519_key
              -----BEGIN OPENSSH PRIVATE KEY-----
              b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
              QyNTUxOQAAACD4KfeSJvN9YepRicOa5G70TNjMqDjfSOpaqu5VnDgtHQAAAJiNVtJtjVbS
              bQAAAAtzc2gtZWQyNTUxOQAAACD4KfeSJvN9YepRicOa5G70TNjMqDjfSOpaqu5VnDgtHQ
              AAAEDHhSiQkdl3G5aHoCJb1Wz0ANjsSUDji3PM83Nx+PsgJfgp95Im831h6lGJw5rkbvRM
              2MyoON9I6lqq7lWcOC0dAAAAEGx1Y2FzZkBhcmNobGludXgBAgMEBQ==
              -----END OPENSSH PRIVATE KEY-----
              EOF
          '';
      };
  };

  age.secrets.axiom-primary-wireguard-priv = {
    file = ../secrets/axiom-primary-wireguard-priv.key.age;
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  age.secrets.k3s-token.file = ../secrets/k3s-token.txt.age;
}
