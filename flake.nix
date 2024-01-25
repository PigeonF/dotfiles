{
  description = "PigeonF's configuration files";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
  };

  outputs = {self, ...} @ inputs: let
    lib = import ./lib {inherit inputs;};
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = lib.mkNixOsConfigurations {
      nixbox = {
        system = "x86_64-linux";
        config = ./hosts/nixbox;
        home = {
          home-manager.users.developer = import ./hosts/nixbox/users/developer.nix;
        };
      };
      gitlab-runner = {
        system = "x86_64-linux";
        config = ./hosts/gitlab-runner;
        extraModules = [inputs.sops-nix.nixosModules.sops];
      };
    };

    darwinConfigurations = lib.mkDarwinConfigurations {
      kamino = {
        system = "aarch64-darwin";
        config = ./hosts/kamino;
        home = {
          home-manager.users.pigeon = import ./hosts/kamino/users/pigeon.nix;
        };
      };
    };

    devShells = lib.forEachSystem (pkgs: {
      default = pkgs.mkShell {
        name = "dotfiles";
        buildInputs = builtins.attrValues {
          inherit (pkgs) age alejandra deadnix just nil sops statix;
        };
      };
    });

    formatter = lib.forEachSystem (pkgs: pkgs.alejandra);

    checks = lib.forEachSystem (pkgs: import ./checks {inherit self pkgs;});
  };
}
