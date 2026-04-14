{ lib, config, ... }:
let
  cfg = config.axiom.secrets;
  hostname = config.networking.hostName;

  # prevents agenix errors when rebuilding
  hasWireguard = builtins.elem hostname [ "axiom-vm-wireguard" ];
  hasK3s = builtins.elem hostname [ "axiom-vm-k8s-master" "axiom-vm-k8s-agent-1" ];
  isGitLab = builtins.elem hostname [ "axiom-vm-gitlab" ];
in
{
  options.axiom.secrets.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable encrypted Axiom secrets";
  };

  config = lib.mkIf cfg.enable {
    age.secrets = lib.mkMerge [
      (lib.mkIf hasWireguard {
        axiom-primary-wireguard-priv = {
          file = ../secrets/axiom-primary-wireguard-priv.key.age;
          mode = "640";
          owner = "systemd-network";
          group = "systemd-network";
        };
      })

      (lib.mkIf hasK3s {
        # k3s-token.file = ../secrets/k3s-token.txt.age;
        axiom-harbor-k8s-registries.file = ../secrets/axiom-harbor-k8s-registries.age;
      })

      (lib.mkIf config.axiom.personal.local-pgp {
        pgp-sign-key = {
          file = ../secrets/pgp-sign-key.age;
          path = "/home/lucasf/.pgp-sign-key";
          mode = "400";
          owner = "lucasf";
          group = "users";
        };
      })

      (lib.mkIf isGitLab {
        axiom-gitlab-db-password.file = ../secrets/axiom-gitlab-db-password.age;
        axiom-gitlab-db-password.owner = "gitlab";
        axiom-gitlab-db-password.group = "gitlab";
        axiom-gitlab-initial-password.file = ../secrets/axiom-gitlab-initial-password.age;
        axiom-gitlab-initial-password.owner = "gitlab";
        axiom-gitlab-initial-password.group = "gitlab";
        axiom-gitlab-secret-activeRecordDeterministicKey.file = ../secrets/axiom-gitlab-secret-activeRecordDeterministicKey.age;
        axiom-gitlab-secret-activeRecordDeterministicKey.owner = "gitlab";
        axiom-gitlab-secret-activeRecordDeterministicKey.group = "gitlab";
        axiom-gitlab-secret-activeRecordPrimaryKey.file = ../secrets/axiom-gitlab-secret-activeRecordPrimaryKey.age;
        axiom-gitlab-secret-activeRecordPrimaryKey.owner = "gitlab";
        axiom-gitlab-secret-activeRecordPrimaryKey.group = "gitlab";
        axiom-gitlab-secret-activeRecordSalt.file = ../secrets/axiom-gitlab-secret-activeRecordSalt.age;
        axiom-gitlab-secret-activeRecordSalt.owner = "gitlab";
        axiom-gitlab-secret-activeRecordSalt.group = "gitlab";
        axiom-gitlab-secret-db.file = ../secrets/axiom-gitlab-secret-db.age;
        axiom-gitlab-secret-db.owner = "gitlab";
        axiom-gitlab-secret-db.group = "gitlab";
        axiom-gitlab-secret-jws.file = ../secrets/axiom-gitlab-secret-jws.age;
        axiom-gitlab-secret-jws.owner = "gitlab";
        axiom-gitlab-secret-jws.group = "gitlab";
        axiom-gitlab-secret-otp.file = ../secrets/axiom-gitlab-secret-otp.age;
        axiom-gitlab-secret-otp.owner = "gitlab";
        axiom-gitlab-secret-otp.group = "gitlab";
        axiom-gitlab-secret-secret.file = ../secrets/axiom-gitlab-secret-secret.age;
        axiom-gitlab-secret-secret.owner = "gitlab";
        axiom-gitlab-secret-secret.group = "gitlab";
        axiom-contabo-s3-access-id.file = ../secrets/axiom-contabo-s3-access-id.age;
        axiom-contabo-s3-access-id.owner = "gitlab";
        axiom-contabo-s3-access-id.group = "gitlab";
        axiom-contabo-s3-access-secret.file = ../secrets/axiom-contabo-s3-access-secret.age;
        axiom-contabo-s3-access-secret.owner = "gitlab";
        axiom-contabo-s3-access-secret.group = "gitlab";
      })
    ];
  };
}
