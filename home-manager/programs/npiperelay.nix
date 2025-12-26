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
  cfg = config.dotfiles.programs.npiperelay;
in
{
  _file = ./npiperelay.nix;

  options.dotfiles.programs = {
    npiperelay = {
      enable = mkEnableOption "set up npiperelay";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [ pkgs.windows.npiperelay ];
      };
    })
  ];
}
