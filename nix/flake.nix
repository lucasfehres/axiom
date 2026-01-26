{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      disko,
      nixpkgs,
      agenix,
    }:
    let
      commonModules = [
        disko.nixosModules.disko
        agenix.nixosModules.default
        ./modules/modules.nix
      ];

      hardwareSupportModules = [
        ./utility/vm.nix
        ./utility/basic-partitioning.nix
      ]

      configModules = {
        nixos-init-test = commonModules ++ [
          ./hosts/nixos-init-test/configuration.nix
        ];
        axiom-vm-wireguard = commonModules ++ [
          ./hosts/axiom-vm-wireguard/configuration.nix
          ./services/wireguard/axiom-primary.nix
        ];
        axiom-vm-k3s-master = commonModules ++ [
          ./hosts/axiom-vm-k3s-master/configuration.nix
          ./services/k3s/k3s-master.nix
        ];
        axiom-vm-k3s-agent-1 = commonModules ++ [
          ./hosts/axiom-vm-k3s-agent-1/configuration.nix
          ./services/k3s/k3s-agent.nix
        ];
        axiom-vm-utility = commonModules ++ [
          ./hosts/axiom-vm-utility/configuration.nix
        ];
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
