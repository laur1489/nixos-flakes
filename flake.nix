{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vice.url = "github:splitshotz/Vice"; # Official Vice repo
  };

  outputs = { self, nixpkgs, vice, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        vice.nixosModules.default # Imports Vice system module & udev rules
        ./configuration.nix
      ];
    };
  };
}
