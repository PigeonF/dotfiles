{inputs}: let
  inherit (inputs.nixpkgs) lib;
  mkOsConfiguration = fn: {
    system,
    config,
    name,
    stateVersion ? "24.05",
    hmStateVersion ? "24.05",
    home ? null,
  }:
    fn {
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
            system = {
              inherit stateVersion;
              configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
            };
            networking.hostName = name;
            nix = {
              package = pkgs.nixFlakes;
              settings = {
                experimental-features = ["nix-command" "flakes"];
              };
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
              home-manager.extraSpecialArgs = {
                inherit inputs pkgs;
                stateVersion = hmStateVersion;
              };
            }
            home
          ]
          else []
        );
    };
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
    lib.nameValuePair name (mkOsConfiguration (lib.nixosSystem) {
      inherit system config stateVersion home name;
      hmStateVersion = stateVersion;
    });

  mkDarwinConfigurations = lib.mapAttrs' mkDarwinConfiguration;
  mkDarwinConfiguration = name: {
    system,
    config,
    stateVersion ? 4,
    hmStateVersion ? "24.05",
    home ? null,
  }:
    lib.nameValuePair name (mkOsConfiguration (inputs.nix-darwin.lib.darwinSystem) {
      inherit system config stateVersion hmStateVersion home name;
    });
}