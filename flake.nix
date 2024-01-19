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

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    flake-utils,
    ...
  }: let
    user = "pigeon";
    stateVersion = "24.05";

    mkDarwin = host: system:
      nix-darwin.lib.darwinSystem
      {
        specialArgs = {inherit inputs user;};

        modules = [
          host

          ({...}: {
            nixpkgs.hostPlatform = system;
          })

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs stateVersion;};
            home-manager.users.${user} = import (host + /home.nix);
          }
        ];
      };

    mkHome = module: system: {username ? user}:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
        };
        modules = [
          module
          {
            home = {
              inherit username stateVersion;
              homeDirectory = "/home/${username}";
            };

            programs.home-manager.enable = true;
          }
        ];
      };
  in
    (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      check = import ./nix/check.nix {inherit pkgs;};
    in {
      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            direnv
            git
            just
            check.check-nixpkgs-fmt
            check.check-editorconfig
          ];
        };
      };
    }))
    // {
      darwinConfigurations."kamino" = mkDarwin ./hosts/kamino "aarch64-darwin";
      homeConfigurations."developer@devbox" = mkHome ./hosts/devbox "x86_64-linux" {username = "developer";};
      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixbox/configuration.nix
          # ({
          #   config,
          #   pkgs,
          #   ...
          # }: {
          #   imports = [
          #     (import "${home-manager}/nixos")
          #   ];

          #   system.stateVersion = stateVersion;

          #   users.users.developer.isNormalUser = true;
          #   home-manager.users.developer =
          #     import ./hosts/devbox {inherit pkgs;}
          #     // {
          #       home.stateVersion = stateVersion;
          #     };
          # })
        ];
      };
    };
}
