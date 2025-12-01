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
  };

  outputs =
    inputs@{
      flake-parts,
      systems,
      home-manager,
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
          ./home-manager
        ];

        flake = { };

        perSystem = { };
      });
}
