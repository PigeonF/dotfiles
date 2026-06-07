{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.presets.containers;
in
{
  _file = ./containers.nix;

  options.dotfiles.presets = {
    containers = {
      enable = mkEnableOption "set up default containers settings";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [
          pkgs.crane
          pkgs.dive
          pkgs.skopeo
        ];
      };
    })
  ];
}
