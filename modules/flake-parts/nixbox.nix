{ inputs, ... }:
{
  flake.nixosConfigurations = {
    nixbox = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };

      modules = [
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager

        ../system/nix.nix
        ../system/core.nix
        ../system/home-manager.nix
        ../../hosts/nixbox
      ];
    };
  };
}
