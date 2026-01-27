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

  nodes.axiom_vm_a_k3s_master = {
    imports = [
      flake.inputs.rke2.nixosModules.default
    ];

    networking.dhcpcd.denyInterfaces = [ "cilium_*" "lxc*" "cali*" "vxlan+" "flannel+" ];

    networking.firewall.enable = false;
    # networking.firewall.checkReversePath = false;
    # networking.firewall.trustedInterfaces = [ "cilium_+" "lxc+" ];

    environment.systemPackages = [
      pkgs.kubectl
      pkgs.cilium-cli
      pkgs.velero
      pkgs.vim
    ];

    services.numtide-rke2 = {
      enable = true;
      role = "server";
      extraFlags = [
        "--disable"
        "rke2-ingress-nginx"
      ];
      settings.kube-apiserver-arg = [ "anonymous-auth=false" ];
      settings.tls-san = [ "192.168.1.1" ];
      settings.write-kubeconfig-mode = "0644";
      settings.cni = "cilium";
      settings.agent-token = "uwubernetes";
      settings.advertise-address = "192.168.1.1";
      settings.node-ip = "192.168.1.1";
    };

    virtualisation.diskSize = 8192;
    virtualisation.memorySize = 8192;
    virtualisation.cores = 4;
  };

  nodes.axiom_vm_k3s_agent_1 = {
    imports = [
      flake.inputs.rke2.nixosModules.default
    ];

    networking.dhcpcd.denyInterfaces = [ "cilium_*" "lxc*" "cali*" "vxlan+" "flannel+" ];

    networking.firewall.enable = false;
    # networking.firewall.checkReversePath = false;
    # networking.firewall.trustedInterfaces = [ "cilium_+" "lxc+" ];

    environment.systemPackages = [
      pkgs.kubectl
      pkgs.cilium-cli
      pkgs.velero
      pkgs.vim
    ];

    services.numtide-rke2 = {
      enable = true;
      role = "agent";
      settings.server = "https://192.168.1.1:9345";
      settings.token = "uwubernetes";
      settings.advertise-address = "192.168.1.2";
      settings.node-ip = "192.168.1.2";
    };

    virtualisation.diskSize = 8192;
    virtualisation.memorySize = 8192;
    virtualisation.cores = 4;
  };

  nodes.axiom_vm_utility = {
    imports = flake.lib.testableConfigModules.axiom-vm-utility ++ [
      ./secrets/dummy-secrets.nix
    ];

    axiom.host.ipv4 = "192.168.1.3";
    axiom.openssh.enable = false;
  };

  # sshBackdoor.enable = true;
  # enableDebugHook = true;

  # https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests
  testScript =
    { nodes, ... }:
    let
      masterIp =
        (pkgs.lib.head nodes.axiom_vm_a_k3s_master.networking.interfaces.eth1.ipv4.addresses).address;
      agent1Ip =
        (pkgs.lib.head nodes.axiom_vm_k3s_agent_1.networking.interfaces.eth1.ipv4.addresses).address;
      utilityIp =
        (pkgs.lib.head nodes.axiom_vm_utility.networking.interfaces.eth1.ipv4.addresses).address;
    in
    ''
      import time
      # print("${masterIp} ${agent1Ip} ${utilityIp}", axiom_vm_a_k3s_master.success("false"))

      axiom_vm_a_k3s_master.start()
      axiom_vm_a_k3s_master.wait_for_unit("default.target")

      axiom_vm_k3s_agent_1.start()
      axiom_vm_k3s_agent_1.wait_for_unit("default.target")

      axiom_vm_utility.start()
      axiom_vm_utility.wait_for_unit("default.target")

      axiom_vm_a_k3s_master.wait_until_succeeds(
        "kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml get --raw=/readyz"
      )

      axiom_vm_a_k3s_master.wait_until_succeeds("cp /etc/rancher/rke2/rke2.yaml /tmp/shared/rke2.yaml")
      print("k3s access file is available on master, setting up utility")
      axiom_vm_utility.succeed("mkdir -p /root/.kube && cp /tmp/shared/rke2.yaml /root/.kube/config")
      axiom_vm_utility.succeed("sed -i 's/127.0.0.1/${masterIp}/' /root/.kube/config")

      print("trying kubectl", axiom_vm_utility.wait_until_succeeds("kubectl get nodes"))

      axiom_vm_a_k3s_master.succeed("systemctl --failed")

      print("waiting for kubernetes node to become ready")
      print("kubectl nodes", axiom_vm_utility.succeed("kubectl wait --for=condition=Ready node -l node-role.kubernetes.io/control-plane=true --timeout=300s"))

      print("waiting for cilium to become ready")
      axiom_vm_utility.succeed("cilium status --wait")

      time.sleep(10)
      print("attempting cilium connectivity")
      print(axiom_vm_utility.succeed("cilium connectivity test"))
    '';
}
