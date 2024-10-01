{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.helix;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.helix = {
    enable = mkEnableOption "PigeonF Helix Packages";
  };

  config = mkIf cfg.enable { home.packages = builtins.attrValues { inherit (pkgs) helix; }; };
}
