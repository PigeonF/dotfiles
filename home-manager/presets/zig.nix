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
  cfg = config.dotfiles.presets.zig;
in
{
  _file = ./zig.nix;

  options.dotfiles.presets = {
    zig = {
      enable = mkEnableOption "set up zig development";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [
          pkgs.zig
          pkgs.zls
        ]
        ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.rr;
      };
    })
  ];
}
