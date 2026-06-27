{
  description = "Nix configurations for my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=refs/heads/release-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=refs/heads/master";
    systems.url = "github:nix-systems/default?ref=refs/heads/main";

    deploy-rs = {
      url = "github:serokell/deploy-rs?ref=refs/heads/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts?ref=refs/heads/main";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils?ref=refs/heads/main";
      inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=refs/heads/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix?ref=refs/heads/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      self,
      systems,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      (_: {
        _file = ./flake.nix;

        systems = import systems;

        imports = [
          home-manager.flakeModules.home-manager
          treefmt-nix.flakeModule
          ./home-manager
        ];

        flake = {
          overlays =
            let
              overlays = {
                unstablePackages = final: _: {
                  unstablePackages = nixpkgs-unstable.legacyPackages.${final.stdenv.hostPlatform.system};
                };
                cargo-deduplicate-warnings = final: _: {
                  cargo-deduplicate-warnings =
                    final.callPackage ./home-manager/packages/cargo-deduplicate-warnings.nix
                      { };
                };
                scrut = final: _: {
                  scrut = final.callPackage ./home-manager/packages/scrut.nix { };
                };
                sdk-apple-darwin = final: _: {
                  sdk-apple-darwin = final.callPackage ./home-manager/packages/sdks/macosx { };
                };
                sdk-pc-windows-msvc = final: _: {
                  sdk-pc-windows-msvc = final.callPackage ./home-manager/packages/sdks/msvc { };
                };
              };
            in
            overlays
            // {
              default = nixpkgs.lib.composeManyExtensions (builtins.attrValues overlays);
            };
        };

        perSystem =
          { inputs', pkgs, ... }:
          {
            _module.args.pkgs = inputs'.nixpkgs.legacyPackages.appendOverlays [
              self.overlays.default
            ];
            treefmt = import ./treefmt.nix;

            checks = {
              reuse =
                let
                  files = pkgs.nix-gitignore.gitignoreSourcePure [ ] (pkgs.lib.cleanSource ./.);
                in
                pkgs.runCommandLocal "reuse" { } ''
                  ${pkgs.lib.getExe pkgs.reuse} --root ${files} lint | tee $out
                '';
            };

            packages = {
              inherit (pkgs)
                cargo-deduplicate-warnings
                scrut
                sdk-apple-darwin
                sdk-pc-windows-msvc
                ;
            };
          };
      });
}
