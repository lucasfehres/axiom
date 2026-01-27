{ config, ... }:
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
    };
}
