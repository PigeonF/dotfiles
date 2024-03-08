{
  description = "PigeonF's configuration files";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # https://github.com/NixOS/nixpkgs/pull/258250
    nixpkgs-networking.url = "github:djacu/nixpkgs/add-networking-lib";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };
    in
    {
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = lib.mkNixOsConfigurations {
        nixbox = {
          system = "x86_64-linux";
          config = ./hosts/nixbox;
          extraModules = [ inputs.sops-nix.nixosModules.sops ];
          home =
            { config, ... }:
            {
              home-manager.users.developer = (import ./hosts/nixbox/users/developer) config;
            };
        };
        gitlab-runner = {
          system = "x86_64-linux";
          config = ./hosts/gitlab-runner;
          extraModules = [ inputs.sops-nix.nixosModules.sops ];
          home = {
            home-manager.users.vagrant = import ./hosts/gitlab-runner/users/vagrant.nix;
          };
        };
      };

      darwinConfigurations = lib.mkDarwinConfigurations {
        kamino = {
          system = "aarch64-darwin";
          config = ./hosts/kamino;
          home = {
            home-manager.users.pigeon = import ./hosts/kamino/users/pigeon.nix;
          };
        };
      };

      devShells = lib.forEachSystem (
        pkgs: {
          default = pkgs.mkShell {
            name = "dotfiles";
            buildInputs = builtins.attrValues {
              inherit (pkgs)
                age
                deadnix
                just
                nil
                nixfmt-rfc-style
                sops
                statix
                ;
            };
          };
        }
      );

      homeConfigurations =
        let
          configurations = lib.forEachSystem (
            pkgs: {
              pigeon = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                extraSpecialArgs = {
                  inherit inputs;
                  stateVersion = "24.05";
                };

                modules = [
                  ./users/common
                  {
                    home.username = "pigeon";
                    home.homeDirectory = "/home/pigeon";
                  }
                ];
              };
            }
          );
        in
        {
          geonosis = configurations.x86_64-linux.pigeon;
        };

      packages = lib.forEachSystem (
        pkgs: {
          committed = pkgs.callPackage ./overlays/committed { };
          gitlab-ci-local = pkgs.callPackage ./overlays/gitlab-ci-local { };
        }
      );

      formatter = lib.forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      checks = lib.forEachSystem (pkgs: import ./checks { inherit self pkgs; });
    };
}
