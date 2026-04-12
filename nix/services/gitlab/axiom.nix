{ config, ... }:
{
  services.gitlab = {
    enable = true;
    host = "gitlab.internal.axiom.lucasfehres.nl";
    port = 443;
    databasePasswordFile = config.age.secrets.axiom-gitlab-db-password.path;
    initialRootPasswordFile = config.age.secrets.axiom-gitlab-initial-password.path;

    sidekiq = {
      concurrency = 2;
    };

    puma = {
      threadsMax = 2;
      workers = 1;
    };

    secrets = {
      activeRecordDeterministicKeyFile = config.age.secrets.axiom-gitlab-secret-activeRecordDeterministicKey.file;
      activeRecordPrimaryKeyFile = config.age.secrets.axiom-gitlab-secret-activeRecordPrimaryKey.file;
      activeRecordSaltFile = config.age.secrets.axiom-gitlab-secret-activeRecordSalt.file;
      dbFile = config.age.secrets.axiom-gitlab-secret-db.file;
      jwsFile = config.age.secrets.axiom-gitlab-secret-jws.file;
      otpFile = config.age.secrets.axiom-gitlab-secret-otp.file;
      secretFile = config.age.secrets.axiom-gitlab-secret-secret.file;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      localhost = {
        locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
    };
  };
}
