{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, flake-utils, ... }:
    let
      username = "pigeon";
      stateVersion = "23.05";

      mkDarwin = host: system: nix-darwin.lib.darwinSystem
        {
          specialArgs = { inherit inputs; user = username; };

          modules = [
            host

            ({ ... }: {
              nixpkgs.hostPlatform = system;
            })

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs stateVersion; };
              home-manager.users.${username} = import (host + /home.nix);
            }
          ];
        };

      mkHome = module: system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
        };
        modules = [
          module
          {
            home = {
              inherit username stateVersion;
              homeDirectory = "/home/${username}";
            };

            programs.home-manager.enable = true;
          }
        ];
      };
    in
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        check = import ./nix/check.nix { inherit pkgs; };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              direnv
              git
              just
              check.check-nixpkgs-fmt
              check.check-editorconfig
            ];
          };
        };

        formatter = pkgs.nixpkgs-fmt;

        checks =
          {
            check-nixpkgs-fmt = pkgs.runCommand "check-nixpkgs-fmt" { buildInputs = [ check.check-nixpkgs-fmt ]; } ''
              cd ${./.}
              check-nixpkgs-fmt
              touch $out
            '';
            check-editorconfig = pkgs.runCommand "check-editorconfig" { buildInputs = [ check.check-editorconfig ]; } ''
              cd ${./.}
              check-editorconfig
              touch $out
            '';
          };
      })) //
    {
      darwinConfigurations."kamino" = mkDarwin ./hosts/kamino "aarch64-darwin";
      homeConfigurations."pigeon@devbox" = mkHome ./hosts/devbox "x86_64-linux";
    };
}
