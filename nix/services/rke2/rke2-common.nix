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
      # numtide's default overrides rke2 with a sed on a vendored k3s file that no longer exists
      package = pkgs.rke2;
      settings.advertise-address = config.axiom.host.ipv4;
      settings.node-ip = config.axiom.host.ipv4;
      settings.disable-kube-proxy = "true";
    };

    boot.kernelModules = [ "rbd" "nbd" ];

    # kube-prometheus-stack already runs node exporter on all K8s nodes
    axiom.monitoring.fluent-bit.node-metrics = false;

    # avoids being ratelimited up the ass by Dockerhub
    environment.etc."rancher/rke2/registries.yaml" = {
      mode = "0600";
      source = config.age.secrets.axiom-harbor-k8s-registries.path;
    };
}
