{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.presets.go;
in
{
  _file = ./go.nix;

  options.dotfiles.presets = {
    go = {
      enable = mkEnableOption "set up go development";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs = {
        go = {
          enable = true;
        };
      };
    })
  ];
}
