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
          pkgs.editorconfig-checker
          pkgs.gh
          pkgs.glab
          pkgs.gnumake
          pkgs.jq
          pkgs.just
          pkgs.ltrace
          (lib.hiPrio pkgs.mandoc)
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
