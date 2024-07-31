{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.rust;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.rust = {
    enable = mkEnableOption "PigeonF Rust Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues {
        inherit (pkgs)
          cargo-asm
          cargo-audit
          cargo-auditable
          cargo-binutils
          cargo-bloat
          cargo-cross
          cargo-cyclonedx
          cargo-deny
          cargo-dist
          cargo-geiger
          cargo-hack
          cargo-llvm-cov
          cargo-nextest
          cargo-zigbuild
          rustup
          zig
          ;
      };
    };
  };
}
