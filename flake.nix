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
    {
      darwinConfigurations."kamino" =
        let
          user = "pigeon";
        in
        nix-darwin.lib.darwinSystem
          {
            specialArgs = { inherit inputs; user = user; };

            modules = [
              ./hosts/kamino

              ({ pkgs, ... }: {
                nixpkgs.hostPlatform = "aarch64-darwin";
              })

              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; };
                home-manager.users.${user} = import ./hosts/kamino/home.nix;
              }
            ];
          };
    } // (flake-utils.lib.eachDefaultSystem (system:
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
              nixpkgs-fmt
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
      }));
}
