{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.presets.python;
in
{
  _file = ./python.nix;

  options.dotfiles.presets = {
    python = {
      enable = mkEnableOption "set up python tools";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [
          pkgs.python3
          pkgs.ruff
          pkgs.ty
        ];
      };
    })
  ];
}
