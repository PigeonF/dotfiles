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
  cfg = config.dotfiles.presets.c;
in
{
  _file = ./c.nix;

  options.dotfiles.presets = {
    c = {
      enable = mkEnableOption "set up c development";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [
          pkgs.clang
          pkgs.cmake
          pkgs.gnumake
          pkgs.meson
          pkgs.ninja
        ]
        ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.rr;
      };
    })
  ];
}
