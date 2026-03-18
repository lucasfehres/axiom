{ config, lib, pkgs, ... }:
{
    services.numtide-rke2 = {
      role = "server";
      extraFlags = [
          "--disable"
          "rke2-ingress-nginx"
      ];
      settings.kube-apiserver-arg = [ "anonymous-auth=false" ];
      settings.tls-san = [ "${config.axiom.k8s.master-ipv4}" ];
      settings.write-kubeconfig-mode = "0644";
      settings.cni = "cilium";
      settings.agent-token = "uwubernetes";

      manifests = {
        "axiom-rke2-cilium.yaml" = ./manifests/axiom-rke2-cilium.yaml;
      };
    };

    # this is broken upstream of the numtide-rke2 and that is unmaintained unfortunately
    systemd.services.numtide-rke2.serviceConfig.ExecStartPre = let
      cfg = config.services.numtide-rke2;
    in lib.mkForce (pkgs.writeShellScript "rke2-exec-start-pre" (''
      set -euo pipefail

      # Remove old nix manifests
      ${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir}/server/manifests
      # Remove old symlinks and previously copied files
      ${pkgs.findutils}/bin/find ${cfg.dataDir}/server/manifests -type l -delete
      ${pkgs.findutils}/bin/find ${cfg.dataDir}/server/manifests -maxdepth 1 -type f -delete
    ''
    + (lib.optionalString (cfg.role == "server" && cfg.manifests != { }) ''
      # Copy all the manifests (instead of symlink) so RKE2 can modify them
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: file:
        "${pkgs.coreutils}/bin/cp --no-preserve=mode ${file} ${cfg.dataDir}/server/manifests/${name}"
      ) cfg.manifests)}
    '')));
}
