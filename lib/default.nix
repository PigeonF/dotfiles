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
  }:
    lib.nameValuePair name (lib.nixosSystem {
      inherit system;
      specialArgs = {inherit name inputs;};
      modules = [
        ({
          name,
          inputs,
          ...
        }: {
          networking.hostName = name;
          nixpkgs = {pkgs = inputs.nixpkgs.legacyPackages.${system};};
        })
        (import config)
      ];
    });

  mkDarwinConfigurations = lib.mapAttrs' mkDarwinConfiguration;
  mkDarwinConfiguration = name: {
    system,
    config,
  }:
    lib.nameValuePair name (inputs.nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs = {inherit name inputs;};
      modules = [
        ({
          name,
          inputs,
          ...
        }: {
          networking.hostName = name;
          nixpkgs = {
            pkgs = inputs.nixpkgs.legacyPackages.${system};
          };
        })
        (import config)
      ];
    });

  mkHomeConfigurations = lib.mapAttrs' mkHomeConfiguration;
  mkHomeConfiguration = name: {
    system,
    home,
    username ? name,
    stateVersion ? "24.05",
  }:
    lib.nameValuePair name (inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        ({pkgs, ...}: {
          home = {
            inherit username stateVersion;

            homeDirectory =
              if pkgs.stdenv.isDarwin
              then "/Users/${username}"
              else "/home/${username}";
          };

          programs.home-manager.enable = true;
        })
        (import home)
      ];
    });
}
