{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.bat;
in
{
  _file = ./bat.nix;

  options.dotfiles.programs = {
    bat = {
      enable = mkEnableOption "set up bat";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        bat = {
          inherit (cfg) enable;
        };
      };
    }
    (lib.mkIf cfg.enable {
      home = {
        shellAliases = {
          cat = "bat --paging=never";
        };
      };
    })
  ];
}
