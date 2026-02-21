{ config, pkgs, ... }:
{
    networking.dhcpcd.denyInterfaces = [ "cilium_*" "lxc*" "cali*" "vxlan+" "flannel+" ];

    networking.firewall.enable = false;

    environment.systemPackages = [
      pkgs.kubectl
      pkgs.kubectl-cnpg
      pkgs.kubectl-rook-ceph
      pkgs.kubectl-df-pv
      pkgs.kubectl-klock
      pkgs.cilium-cli
      pkgs.velero
      pkgs.fluxcd
    ];

    services.numtide-rke2 = {
      enable = true;
      settings.advertise-address = config.axiom.host.ipv4;
      settings.node-ip = config.axiom.host.ipv4;
    };

    boot.kernelModules = [ "rbd" "nbd" ];
}
