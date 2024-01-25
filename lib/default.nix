{inputs}: let
  inherit (inputs.nixpkgs) lib;
  mkOsConfiguration = fn: {
    system,
    config,
    name,
    stateVersion,
    hmStateVersion,
    home,
    extraModules,
  }:
    fn {
      inherit system;
      specialArgs = {inherit name inputs;};
      modules = let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.self.outputs.overlays.additions
          ];
        };
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
        ++ extraModules
        ++ (
          if home != null
          then [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs pkgs;
                  stateVersion = hmStateVersion;
                };
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
        overlays = [
          inputs.self.outputs.overlays.additions
        ];
      }));

  mkNixOsConfigurations = lib.mapAttrs' mkNixOsConfiguration;
  mkNixOsConfiguration = name: {
    system,
    config,
    stateVersion ? "24.05",
    home ? null,
    extraModules ? [],
  }:
    lib.nameValuePair name (mkOsConfiguration lib.nixosSystem {
      inherit system config stateVersion home name extraModules;
      hmStateVersion = stateVersion;
    });

  mkDarwinConfigurations = lib.mapAttrs' mkDarwinConfiguration;
  mkDarwinConfiguration = name: {
    system,
    config,
    stateVersion ? 4,
    hmStateVersion ? "24.05",
    home ? null,
    extraModules ? [],
  }:
    lib.nameValuePair name (mkOsConfiguration inputs.nix-darwin.lib.darwinSystem {
      inherit system config stateVersion hmStateVersion home name extraModules;
    });
}
