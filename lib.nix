{ inputs, ... }:

{
  flake.lib = {
    mkNixosConfiguration =
      system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
          isLinux = true;
        };

        modules = modules ++ [
          (
            { lib, ... }:
            {
              system.stateVersion = lib.mkDefault "24.05";
              nixpkgs.hostPlatform = lib.mkDefault system;
            }
          )
        ];
      };

    mkDarwinConfiguration =
      system: modules:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
          isLinux = false;
        };

        modules = modules ++ [
          (
            { lib, ... }:
            {
              system.stateVersion = lib.mkDefault 4;
              nixpkgs.hostPlatform = lib.mkDefault system;
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

        modules = modules ++ [ inputs.sops-nix.homeManagerModules.sops ];
      };
  };
}
