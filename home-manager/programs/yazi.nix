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
  cfg = config.dotfiles.programs.yazi;
in
{
  _file = ./yazi.nix;

  options.dotfiles.programs = {
    yazi = {
      enable = mkEnableOption "set up yazi";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        yazi = {
          inherit (cfg) enable;
          extraPackages = [
            pkgs.ouch
          ];
          plugins = {
            inherit (pkgs.yaziPlugins) ouch;
          };
        };
      };
    }
  ];
}
