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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#kamino
      darwinConfigurations."kamino" = nix-darwin.lib.darwinSystem
        {
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/kamino

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."kamino".pkgs;
    };
}
