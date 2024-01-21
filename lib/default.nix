{inputs}: let
  inherit (inputs.nixpkgs) lib;
in rec {
  forEachSystem = lambda:
    lib.genAttrs ["x86_64-linux" "aarch64-darwin"] (system:
      lambda (import inputs.nixpkgs {
        inherit system;
      }));

  mkNixOsConfigurations = lib.mapAttrs' mkNixOsConfiguration;
  mkNixOsConfiguration = name: {
    system,
    config,
    stateVersion ? "24.05",
    home ? null,
  }:
    lib.nameValuePair name (lib.nixosSystem {
      inherit system;
      specialArgs = {inherit name inputs;};
      modules = let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
        [
          ({
            name,
            inputs,
            ...
          }: {
            networking.hostName = name;
            system = {
              inherit stateVersion;
            };
            nixpkgs = {inherit pkgs;};
          })
          (import config)
        ]
        ++ (
          if home != null
          then [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs pkgs stateVersion;};
            }
            home
          ]
          else []
        );
    });

  mkDarwinConfigurations = lib.mapAttrs' mkDarwinConfiguration;
  mkDarwinConfiguration = name: {
    system,
    config,
    stateVersion ? "24.05",
    home ? null,
  }:
    lib.nameValuePair name (inputs.nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs = {inherit name inputs;};
      modules = let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
        [
          ({
            name,
            inputs,
            ...
          }: {
            networking.hostName = name;
            nixpkgs = {
              inherit pkgs;
            };
          })
          (import config)
        ]
        ++ (
          if home != null
          then [
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs pkgs stateVersion;};
            }
            home
          ]
          else []
        );
    });
}
