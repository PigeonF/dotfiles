{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.starship;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.starship = {
    enable = mkEnableOption "PigeonF Starship Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues { inherit (pkgs) sd starship; };
    };
  };
}
