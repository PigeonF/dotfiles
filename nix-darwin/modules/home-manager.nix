{ inputs, ... }:

{
  flake.darwinModules.home-manager = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
          };

          sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
        };

        nixpkgs.overlays = [ inputs.self.overlays.default ];
      }
    ];
  };
}
