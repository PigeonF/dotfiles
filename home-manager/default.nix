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
            ./programs/atuin.nix
            ./programs/bash.nix
            ./programs/bat.nix
            ./programs/btop.nix
            ./programs/eza.nix
            ./programs/fd.nix
            ./programs/fzf.nix
            ./programs/git.nix
            ./programs/helix.nix
            ./programs/home-manager.nix
            ./programs/nix.nix
            ./programs/ripgrep.nix
            ./programs/starship.nix
            ./programs/vivid.nix
            ./programs/zoxide.nix
          ];
        };
        presetsShell = {
          imports = [
            ./modules/presets/shell.nix
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
