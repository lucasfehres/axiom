{ config, ... }:
{
    services.numtide-rke2 = {
      role = "agent";
      settings.server = "https://${config.axiom.k8s.master-ipv4}:9345";
      settings.token = "uwubernetes";
    };
}
