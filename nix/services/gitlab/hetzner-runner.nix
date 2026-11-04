{ config, pkgs, ... }:
let
  user = "gitlab-hetzner-runner";
  stateDir = "/var/lib/${user}";
  pluginDir = "${stateDir}/plugins";
  runner = "${pkgs.gitlab-runner}/bin/gitlab-runner";
  configPath = config.age.secrets.axiom-gitlab-hetzner-runner-config.path;
in
{
  users.users.${user} = {
    isSystemUser = true;
    group = user;
    home = stateDir;
  };
  users.groups.${user} = { };

  environment.systemPackages = with pkgs; [
    gitlab-runner
  ];

  systemd.services.gitlab-hetzner-runner = {
    description = "GitLab Runner (Hetzner fleeting autoscaler)";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    environment = {
      FLEETING_PLUGIN_PATH = pluginDir;
      HOME = stateDir;
    };

    serviceConfig = {
      User = user;
      Group = user;
      StateDirectory = user;

      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p ${pluginDir}"
        "${runner} fleeting --config ${configPath} install"
      ];
      ExecStart = "${runner} run --config ${configPath} --working-directory ${stateDir}";

      Restart = "always";
      RestartSec = 10;
      KillSignal = "SIGQUIT"; # graceful: let running jobs finish
      TimeoutStopSec = 600;
    };
  };
}
