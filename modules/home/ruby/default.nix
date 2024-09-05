{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.ruby;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.ruby = {
    enable = mkEnableOption "PigeonF Ruby Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.ruby ];
    };
  };
}
