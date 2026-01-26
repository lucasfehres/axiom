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
    {
      nixosConfigurations = {
        nixos-init-test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            agenix.nixosModules.default

            ./modules/modules.nix

            ./hosts/nixos-init-test/configuration.nix
            ./utility/vm.nix
            ./utility/basic-partitioning.nix
          ];
        };
        axiom-vm-wireguard = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            agenix.nixosModules.default

            ./modules/modules.nix

            ./hosts/axiom-vm-wireguard/configuration.nix
            ./utility/vm.nix
            ./utility/basic-partitioning.nix

            ./services/wireguard/axiom-primary.nix
          ];
        };
        axiom-vm-k3s-master = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            agenix.nixosModules.default

            ./modules/modules.nix

            ./hosts/axiom-vm-k3s-master/configuration.nix
            ./utility/vm.nix
            ./utility/basic-partitioning.nix

            ./services/k3s/k3s-master.nix
          ];
        };
        axiom-vm-utility = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            agenix.nixosModules.default

            ./modules/modules.nix

            ./hosts/axiom-vm-utility/configuration.nix
            ./utility/vm.nix
            ./utility/basic-partitioning.nix
          ];
        };
      };
    };
}
