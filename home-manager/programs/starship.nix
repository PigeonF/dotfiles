{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.starship;
in
{
  _file = ./starship.nix;

  options.dotfiles.programs = {
    starship = {
      enable = mkEnableOption "set up starship";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        starship = {
          inherit (cfg) enable;
        };
      };
    }
  ];
}
