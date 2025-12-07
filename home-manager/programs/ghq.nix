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
  cfg = config.dotfiles.programs.ghq;
in
{
  _file = ./ghq.nix;

  options.dotfiles.programs = {
    ghq = {
      enable = mkEnableOption "set up ghq";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [ pkgs.ghq ];
        sessionVariables = {
          GHQ_ROOT = "$HOME/git";
        };
      };
    })
  ];
}
