{ lib, ... }:

{
  options.axiom.k8s.master-ipv4 = lib.mkOption {
    type = lib.types.str;
    default = "10.67.1.103";
    description = "Kubernetes master address";
  };
}
