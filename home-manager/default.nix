{ inputs, ... }:
{
  _file = ./default.nix;

  imports = [
    ./flake-module.nix
  ];

  flake =
    let
      homeModules = {
        dotter = {
          imports = [
            ./modules/dotter.nix
          ];
        };
        programs = {
          imports = [
            ./programs/helix.nix
          ];
        };
      };
    in
    {
      homeModules = homeModules // {
        default = {
          imports = builtins.attrValues homeModules;
        };
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      homeConfigurations = {
        administrator = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            inputs.self.homeModules.default
            ./users/administrator.nix
          ];
        };
      };
    };
}
