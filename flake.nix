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

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        ./all-modules.nix
        ./lib.nix

        ./home-manager
        ./nixos
      ];

      flake = {
        overlays = import ./overlays inputs;

        flakeModules = {
          default = ./all-modules.nix;
          homeModules = ./extras/homeModules.nix;
          darwinModules = ./extras/darwinModules.nix;
        };

        nixosConfigurations =
          let
            inherit (inputs.self.lib) mkNixosConfiguration;
          in
          {
            geonosis = mkNixosConfiguration "x86_64-linux" [ inputs.self.nixosModules.geonosis ];
            mustafar = mkNixosConfiguration "x86_64-linux" [ inputs.self.nixosModules.mustafar ];
            coruscant = mkNixosConfiguration "x86_64-linux" [ inputs.self.nixosModules.coruscant ];
          };

        darwinConfigurations =
          let
            inherit (inputs.self.lib) mkDarwinConfiguration;
          in
          {
            kamino = mkDarwinConfiguration "aarch64-darwin" [ ./nix-darwin/systems/kamino ];
          };
      };

      perSystem =
        { inputs', pkgs, ... }:
        let
          inherit (inputs) self;
          inherit (pkgs) runCommand;
          inherit (pkgs.lib) getExe;
        in
        {
          _module.args.pkgs = inputs'.nixpkgs.legacyPackages.extend inputs.self.overlays.default;

          formatter = pkgs.nixfmt-rfc-style;

          packages = {
            inherit (pkgs) committed gitlab-ci-local;
          };

          legacyPackages.homeConfigurations =
            let
              mkHomeConfiguration = self.lib.mkHomeConfiguration pkgs;
            in
            {
              pigeon = mkHomeConfiguration [ inputs.self.homeModules.users.pigeon ];
            };

          checks = {
            deadnix = runCommand "check-deadnix" { } ''
              ${getExe pkgs.deadnix} -f ${self} | tee $out
            '';
            nixfmt = runCommand "check-nixfmt" { } ''
              ${getExe pkgs.nixfmt-rfc-style} --check ${self} | tee $out
            '';
            statix = runCommand "check-statix" { } ''
              ${getExe pkgs.statix} check ${self} | tee $out
            '';
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

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-pigeonf.url = "github:PigeonF/nixpkgs?ref=init-committed";
    # https://github.com/NixOS/nixpkgs/pull/258250
    nixpkgs-networking.url = "github:djacu/nixpkgs?ref=add-networking-lib";
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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
