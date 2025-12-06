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
  cfg = config.dotfiles.programs.zoxide;
in
{
  _file = ./zoxide.nix;

  options.dotfiles.programs = {
    zoxide = {
      enable = mkEnableOption "set up zoxide";
    };
  };

  config = lib.mkMerge [
    {
      home = {
        packages = [ pkgs.fzf ];
      };
      programs = {
        zoxide = {
          inherit (cfg) enable;
        };
      };
    }
  ];
}
