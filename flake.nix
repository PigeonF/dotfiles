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
    homeConfigurations = lib.mkHomeConfigurations {
      developer = {
        system = "x86_64-linux";
        home = ./hosts/devbox;
      };
      pigeon = {
        system = "aarch64-darwin";
        home = ./hosts/kamino/home.nix;
      };
    };

    nixosConfigurations = lib.mkNixOsConfigurations {
      nixbox = {
        system = "x86_64-linux";
        config = ./hosts/nixbox/configuration.nix;
      };
    };

    darwinConfigurations = lib.mkDarwinConfigurations {
      kamino = {
        system = "aarch64-darwin";
        config = ./hosts/kamino;
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
