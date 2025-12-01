{ inputs, ... }:
{
  _file = ./default.nix;

  imports = [
    ./flake-module.nix
  ];

  flake = { };

  perSystem =
    { pkgs, ... }:
    {
      homeConfigurations = {
        administrator = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./users/administrator.nix
          ];
        };
      };
    };
}
