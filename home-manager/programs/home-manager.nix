{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.home-manager;
in
{
  _file = ./home-manager.nix;

  options.dotfiles.programs = {
    home-manager = {
      enable = mkEnableOption "set up home-manager";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        home-manager = {
          inherit (cfg) enable;
        };
      };
    }
  ];
}
