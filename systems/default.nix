{ inputs, ... }:

{
  _file = ./default.nix;

  flake = {
    checks = builtins.mapAttrs (
      _: deployLib: deployLib.deployChecks inputs.self.deploy
    ) inputs.deploy-rs.lib;

    deploy.nodes = {
      tatooine = {
        hostname = "tatooine";
        profiles = {
          system = {
            sshUser = "administrator";
            user = "root";
            path = inputs.deploy-rs.lib."aarch64-linux".activate.nixos inputs.self.nixosConfigurations.tatooine;
          };
        };
      };
    };

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
