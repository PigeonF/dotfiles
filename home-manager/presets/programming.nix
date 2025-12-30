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
  cfg = config.dotfiles.presets.programming;
in
{
  _file = ./programming.nix;

  options.dotfiles.presets = {
    programming = {
      enable = mkEnableOption "set up general purpose programming tools";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [
          pkgs.gh
          pkgs.glab
          pkgs.just
          pkgs.ltrace
          pkgs.reuse
          pkgs.strace
          pkgs.tombi
          pkgs.typos
          pkgs.vscode-json-languageserver
          pkgs.yaml-language-server
        ];
      };
    })
  ];
}
