{ inputs, ... }:

{
  flake.lib = {
    mkNixosConfiguration =
      system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = modules ++ [
          (
            { lib, ... }:
            {
              system.stateVersion = lib.mkDefault "24.05";
            }
          )
        ];
      };

    mkHomeConfiguration =
      pkgs: modules:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit inputs;
        };

        sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];

        inherit modules;
      };
  };
}