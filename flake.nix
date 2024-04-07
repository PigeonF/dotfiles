{
  description = "PigeonF's configuration files";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://pigeonf.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "pigeonf.cachix.org-1:YS6DrTg749PUeiYFojsT6CbwQnvPMnjtB3crKckdNvw="
    ];
  };

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
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = import ./lib { inherit inputs; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        ./modules/flake-parts/nixbox.nix
        ./modules/flake-parts/gitlab-runner.nix
      ];

      flake = {
        overlays = import ./overlays inputs;

        darwinConfigurations = lib.mkDarwinConfigurations {
          kamino = {
            system = "aarch64-darwin";
            config = ./hosts/kamino;
            home = {
              home-manager.users.pigeon = import ./hosts/kamino/users/pigeon.nix;
            };
          };
        };

        checks = lib.forEachSystem (
          pkgs:
          import ./checks {
            inherit (inputs) self;
            inherit pkgs;
          }
        );
      };

      perSystem =
        { inputs', pkgs, ... }:
        {
          _module.args.pkgs = inputs'.nixpkgs.legacyPackages.extend inputs.self.overlays.additions;

          formatter = pkgs.nixfmt-rfc-style;

          packages = {
            inherit (pkgs) committed gitlab-ci-local;
          };

          legacyPackages.homeConfigurations = {
            geonosis = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;

              extraSpecialArgs = {
                inherit inputs;
              };

              modules = [
                ./users/common
                {
                  home.username = "pigeon";
                  home.homeDirectory = "/home/pigeon";
                  home.stateVersion = "24.05";
                }
              ];
            };
          };

          devShells = {
            default = pkgs.mkShell {
              name = "pigeonf-dotfiles";
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
          };
        };
    };
}
