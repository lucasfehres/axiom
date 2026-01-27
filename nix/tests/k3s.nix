{ ... }:
let
  flake = builtins.getFlake (toString ./..);
  pkgs = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config = { };
    overlays = [ ];
  };
in
pkgs.testers.runNixOSTest {
  name = "test-k3s";

  nodes.axiom_vm_k3s_master = {
    imports = flake.lib.testableConfigModules.axiom-vm-k3s-master ++ [
      ./secrets/dummy-secrets.nix
      # ../utility/vm-networkd.nix
    ];

    host.ipv4 = "192.168.1.1";
    axiom.openssh.enable = false;

    virtualisation.diskSize = 8192;
    virtualisation.memorySize = 8192;
    virtualisation.cores = 4;
  };

  nodes.axiom_vm_utility = {
    imports = flake.lib.testableConfigModules.axiom-vm-utility ++ [
      ./secrets/dummy-secrets.nix
    ];

    host.ipv4 = "192.168.1.2";
    axiom.openssh.enable = false;
  };

  sshBackdoor.enable = true;
  # enableDebugHook = true;

  # https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests
  testScript =
    { nodes, ... }:
    let
      masterIp =
        (pkgs.lib.head nodes.axiom_vm_k3s_master.networking.interfaces.eth1.ipv4.addresses).address;
      utilityIp =
        (pkgs.lib.head nodes.axiom_vm_utility.networking.interfaces.eth1.ipv4.addresses).address;
    in
    ''
      import time
      # print("${masterIp} ${utilityIp}", axiom_vm_k3s_master.success("false"))

      axiom_vm_k3s_master.start()
      axiom_vm_utility.start()
      axiom_vm_k3s_master.wait_for_unit("default.target")
      axiom_vm_utility.wait_for_unit("default.target")

      axiom_vm_k3s_master.wait_until_succeeds(
        "kubectl --kubeconfig=/etc/rancher/k3s/k3s.yaml get --raw=/readyz"
      )

      axiom_vm_k3s_master.wait_until_succeeds("cp /etc/rancher/k3s/k3s.yaml /tmp/shared/k3s.yaml")
      print("k3s access file is available on master, setting up utility")
      axiom_vm_utility.succeed("mkdir -p /root/.kube && cp /tmp/shared/k3s.yaml /root/.kube/config")
      axiom_vm_utility.succeed("sed -i 's/127.0.0.1/${masterIp}/' /root/.kube/config")

      print("trying kubectl", axiom_vm_utility.wait_until_succeeds("kubectl get nodes"))

      axiom_vm_k3s_master.succeed("systemctl --failed")

      # print("installing cilium")
      time.sleep(10)
      axiom_vm_utility.wait_until_succeeds('cilium install --version 1.18.6 --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16"')

      # axiom_vm_utility.succeed("""
      #   cilium install --version 1.18.6 \
      #     --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" \
      #     --set=kubeProxyReplacement=true \
      #     --set=k8sServiceHost="${masterIp}" \
      #     --set=k8sServicePort="6443" \
      #     --set=bpf.masquerade=true \
      #     --set=routingMode=native \
      #     --set=autoDirectNodeRoutes=true \
      #     --set=ipv4NativeRoutingCIDR=10.42.0.0/16
      # """)

      print("waiting for kubernetes node to become ready")
      axiom_vm_utility.succeed("kubectl wait --for=condition=Ready node -l node-role.kubernetes.io/control-plane=true --timeout=300s")

      print("waiting for cilium to become ready")
      axiom_vm_utility.succeed("cilium status --wait")

      print(axiom_vm_utility.succeed("kubectl describe node axiom-vm-k3s-master"))
      print(axiom_vm_utility.succeed("cilium status"))

      time.sleep(10)
      print("attempting cilium connectivity")
      axiom_vm_utility.succeed("cilium connectivity test")
    '';
}
