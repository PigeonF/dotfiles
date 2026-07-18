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
          pkgs.debian-devscripts
          (pkgs.writeShellApplication {
            name = "docker-credential-glab";
            runtimeInputs = [
              pkgs.glab
            ];
            text = ''
              exec glab auth docker-helper "$@"
            '';
          })
          pkgs.file
          pkgs.gh
          pkgs.glab
          pkgs.gnumake
          pkgs.gnupg
          pkgs.jq
          pkgs.just
          pkgs.ltrace
          (lib.hiPrio pkgs.mandoc)
          pkgs.reuse
          pkgs.sequoia-sq
          pkgs.scrut
          pkgs.sd
          pkgs.semgrep
          pkgs.strace
          pkgs.syft
          pkgs.tealdeer
          pkgs.tombi
          pkgs.typos
          pkgs.vscode-json-languageserver
          pkgs.yaml-language-server
          pkgs.xxd
          pkgs.xz
          pkgs.zip
        ];
      };
    })
  ];
}
