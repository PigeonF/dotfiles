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
  cfg = config.dotfiles.programs.rustup;
in
{
  _file = ./rustup.nix;

  options.dotfiles.programs = {
    rustup = {
      enable = mkEnableOption "set up rustup";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [ pkgs.rustup ];
      };
    })
    (lib.mkIf cfg.enable {
      home = {
        sessionVariables = {
          RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        };
      };
    })
  ];
}
