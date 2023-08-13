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
      darwinConfigurations."kamino" =
        let
          user = "pigeon";
        in
        nix-darwin.lib.darwinSystem
          {
            specialArgs = { inherit inputs; };

            modules = [
              ./hosts/kamino

              ({ pkgs, ... }: {
                nixpkgs.hostPlatform = "aarch64-darwin";
                users.users.${user} = {
                  home = "/Users/${user}";
                  shell = pkgs.zsh;
                };

                system = {
                  configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
                  stateVersion = 4;
                };

                nix = {
                  package = pkgs.nixFlakes;
                  settings = {
                    allowed-users = [ user ];
                    experimental-features = [ "nix-command" "flakes" ];
                  };
                };
              })

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
