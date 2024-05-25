{ inputs, ... }:

{
  flake.nixosConfigurations = {
    geonosis = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./geonosis
        (_: {
          system.stateVersion = "24.05";
          nixpkgs.hostPlatform = "x86_64-linux";
        })
      ];
    };
  };
}
