{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      disko,
      nixpkgs,
    }:
    {
      nixosConfigurations = {
        nixos-init-test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos-init-test/configuration.nix
            ./utility/vm.nix
          ];
        };
      };
    };
}
