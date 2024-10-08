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
        {
          inputs',
          pkgs,
          lib,
          ...
        }:
        let
          inherit (inputs) self;
          inherit (pkgs) runCommand;
          inherit (pkgs.lib) getExe;
        in
        {
          _module.args.pkgs = inputs'.nixpkgs.legacyPackages.appendOverlays [
            inputs.self.overlays.default
            inputs.typst.overlays.default
          ];

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
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    cloudflare-ipv6s = {
      url = "https://www.cloudflare.com/ips-v6";
      flake = false;
    };
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    typst = {
      url = "github:typst/typst";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    jujutsu = {
      url = "github:martinvonz/jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
