{ config, ... }:
{
  services.gitlab = {
    enable = true;
    host = "gitlab.internal.axiom.lucasfehres.nl";
    port = 443;
    https = true;
    databasePasswordFile = config.age.secrets.axiom-gitlab-db-password.path;
    initialRootPasswordFile = config.age.secrets.axiom-gitlab-initial-password.path;

    extraGitlabRb = ''
      Settings.gitlab_kas[‘enable’] = true
    '';

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

    backup = {
      # keeping backups around for 2 weeks
      keepTime = 336;
      startAt = ["03:00"];
      skip = [ "artifacts" ];
      uploadOptions = {
        # Fog storage connection settings, see http://fog.io/storage/
        connection = {
          provider = "AWS";
          region = "";
          aws_access_key_id = { _secret = config.age.secrets.axiom-contabo-s3-access-id.file; };
          aws_secret_access_key = { _secret = config.age.secrets.axiom-contabo-s3-access-secret.file; };
          endpoint = "https://eu2.contabostorage.com";
        };

        # The remote 'directory' to store your backups in.
        # For S3, this would be the bucket name.
        remote_directory = "lucasfehres.axiom.gitlab-backup";

        # Use multipart uploads when file size reaches 100MB, see
        # http://docs.aws.amazon.com/AmazonS3/latest/dev/uploadobjusingmpu.html
        multipart_chunk_size = 104857600;
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      localhost = {
        locations."/"= {
          proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
            proxy_set_header X-Forwarded-Ssl on;
          '';
        };
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto https;
          proxy_set_header X-Forwarded-Ssl on;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
  ];
}
