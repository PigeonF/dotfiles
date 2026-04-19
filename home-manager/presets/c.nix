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
          pkgs.clang-tools
          pkgs.cmake
          pkgs.gdb
          pkgs.gnumake
          # pkgs.pkgsCross.aarch64-multiplatform.gcc
          # pkgs.pkgsCross.s390x.gcc
          pkgs.lldb
          pkgs.meson
          pkgs.ninja
          pkgs.pkg-config
        ]
        ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.rr;
      };
    })
  ];
}
