{
  description = "PigeonF's configuration files";

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
  };

  outputs = {self, ...} @ inputs: let
    lib = import ./lib {inherit inputs;};
  in rec {
    nixosConfigurations = lib.mkNixOsConfigurations {
      nixbox = {
        system = "x86_64-linux";
        config = ./hosts/nixbox/configuration.nix;
        home = {
          home-manager.users.developer = import ./hosts/devbox;
        };
      };
    };

    darwinConfigurations = lib.mkDarwinConfigurations {
      kamino = {
        system = "aarch64-darwin";
        config = ./hosts/kamino;
        home = {
          home-manager.users.pigeon = import ./hosts/kamino/home.nix;
        };
      };
    };

    devShells = lib.forEachSystem (pkgs: {
      default = pkgs.mkShell {
        name = "dotfiles";
        buildInputs = with pkgs; [alejandra nil];
      };
    });
  };
}
