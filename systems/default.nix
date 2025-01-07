{ inputs, ... }:

{
  _file = ./default.nix;

  flake = {
    nixosConfigurations = {
      geonosis = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };

        modules = [ ./geonosis ];
      };

      tatooine = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };

        modules = [ ./tatooine ];
      };
    };
  };
}
