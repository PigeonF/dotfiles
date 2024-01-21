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
    stateVersion ? 4,
    hmStateVersion ? "24.05",
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
            nixpkgs = {
              inherit pkgs;
            };
            manual = {
              html.enable = false;
              manpages.enable = false;
              json.enable = false;
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
              home-manager.extraSpecialArgs = {
                inherit inputs pkgs;
                stateVersion = hmStateVersion;
              };
            }
            home
          ]
          else []
        );
    });
}
