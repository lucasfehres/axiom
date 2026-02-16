{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    rke2.url = "github:numtide/nixos-rke2";
    rke2.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      disko,
      nixpkgs,
      agenix,
      rke2,
      home-manager
    }:
    let
      commonModules = [
        disko.nixosModules.disko
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        ./users/lucasf/user.nix
        ./modules/modules.nix
        ./utility/general.nix
      ];

      hardwareSupportModules = [
        ./utility/vm.nix
        ./utility/basic-partitioning.nix
      ];

      configModules = {
        nixos-init-test = commonModules ++ [
          ./hosts/nixos-init-test/configuration.nix
        ];
        axiom-vm-wireguard = commonModules ++ [
          ./hosts/axiom-vm-wireguard/configuration.nix
          ./services/wireguard/axiom-primary.nix
        ];
        axiom-vm-k8s-master = commonModules ++ [
          rke2.nixosModules.default
          ./hosts/axiom-vm-k8s-master/configuration.nix
          ./services/rke2/rke2-common.nix
          ./services/rke2/rke2-master.nix
        ];
        axiom-vm-k8s-agent-1 = commonModules ++ [
          rke2.nixosModules.default
          ./hosts/axiom-vm-k8s-agent-1/configuration.nix
          ./services/rke2/rke2-common.nix
          ./services/rke2/rke2-agent.nix
        ];
        axiom-vm-utility = commonModules ++ [
          ./hosts/axiom-vm-utility/configuration.nix
        ];
        axiom-vm-games = commonModules ++ [
          ./hosts/axiom-vm-games/configuration.nix
          ./services/podman/podman.nix
        ]
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        name: modules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = modules ++ hardwareSupportModules;
        }
      ) configModules;

      lib.testableConfigModules = configModules;
    };
}
