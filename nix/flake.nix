{
  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    rke2.url = "github:numtide/nixos-rke2";
    rke2.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # unstable variants
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    plasma-manager-unstable.url = "github:nix-community/plasma-manager";
    plasma-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    plasma-manager-unstable.inputs.home-manager.follows = "home-manager-unstable";
  };
  outputs =
    {
      self,
      disko,
      nixpkgs,
      agenix,
      rke2,
      home-manager,
      plasma-manager,
      nur,
      determinate,
      nixos-hardware,
      nixpkgs-unstable,
      home-manager-unstable,
      plasma-manager-unstable
    }:
    let
      mkCommonModules = homeManager: [
        nur.modules.nixos.default

        disko.nixosModules.disko
        agenix.nixosModules.default
        homeManager.nixosModules.home-manager

        ./users/lucasf/user.nix
        ./modules/modules.nix
        ./utility/general.nix
      ];

      commonModules = mkCommonModules home-manager;
      commonModulesUnstable = mkCommonModules home-manager-unstable;

      vmSupportModules = [
        ./utility/vm.nix
        ./utility/basic-partitioning.nix
      ];

      configModules = {
        nixos-init-test = commonModules ++ [
          ./hosts/nixos-init-test/configuration.nix
        ] ++ vmSupportModules;
        axiom-vm-wireguard = commonModules ++ [
          ./hosts/axiom-vm-wireguard/configuration.nix
          ./services/wireguard/axiom-primary.nix
        ] ++ vmSupportModules;
        axiom-vm-k8s-master = commonModules ++ [
          rke2.nixosModules.default
          ./hosts/axiom-vm-k8s-master/configuration.nix
          ./services/rke2/rke2-common.nix
          ./services/rke2/rke2-master.nix
        ] ++ vmSupportModules;
        axiom-vm-k8s-agent-1 = commonModules ++ [
          rke2.nixosModules.default
          ./hosts/axiom-vm-k8s-agent-1/configuration.nix
          ./services/rke2/rke2-common.nix
          ./services/rke2/rke2-agent.nix
        ] ++ vmSupportModules;
        axiom-vm-utility = commonModules ++ [
          ./hosts/axiom-vm-utility/configuration.nix
        ] ++ vmSupportModules;
        axiom-vm-games = commonModules ++ [
          ./hosts/axiom-vm-games/configuration.nix
          ./services/podman/podman.nix
        ] ++ vmSupportModules;
        axiom-vm-gitlab = commonModules ++ [
          ./hosts/axiom-vm-gitlab/configuration.nix
        ] ++ vmSupportModules;
      };

      unstableConfigs = {
        laptop-test = commonModulesUnstable ++ [
            ./hosts/laptop-test/configuration.nix

            # try out on the test laptop for now
            determinate.nixosModules.default

            # it's a 3210 but close enough
            nixos-hardware.nixosModules.dell-latitude-3340
        ];

        # https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch
      };
    in
    {
      nixosConfigurations = (builtins.mapAttrs (
        name: modules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = modules;
          specialArgs = {
            inherit
              plasma-manager
              nur
              ;
          };
        }
      ) configModules) //
      (builtins.mapAttrs (name: modules:
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = modules;
          specialArgs = {
            plasma-manager = plasma-manager-unstable;
            inherit nur;
          };
        }
      ) unstableConfigs);

      lib.testableConfigModules = configModules;
    };
}
