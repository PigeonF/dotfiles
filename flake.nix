{
  description = "PigeonF's configuration files";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        (import ./flake-modules.nix).default
        ./modules
        ./systems
        ./homes
      ];

      flake = {
        overlays = import ./overlays inputs;
        flakeModules = import ./flake-modules.nix;
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
            inherit (pkgs) gitlab-ci-local reprotest;
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
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    # For neovim 0.10
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-buildah.url = "github:r-ryantm/nixpkgs/auto-update/buildah-unwrapped";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
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
  };
}
