{
  description = "Nix configurations for my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=refs/heads/release-25.11";
    systems.url = "github:nix-systems/default?ref=refs/heads/main";

    flake-parts = {
      url = "github:hercules-ci/flake-parts?ref=refs/heads/main";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=refs/heads/release-25.11";
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
      systems,
      home-manager,
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

        flake = { };

        perSystem =
          { pkgs, ... }:
          {
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
          };
      });
}
