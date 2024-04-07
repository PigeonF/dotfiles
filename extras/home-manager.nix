{ inputs, ... }:

{
  flake = {
    # Helpers for easily consuming home-manager from a nixosConfiguration.
    nixosModules.home-manager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        }
      ];
    };
  };
}
