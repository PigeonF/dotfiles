{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.atuin;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.atuin = {
    enable = mkEnableOption "PigeonF Atuin Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues { inherit (pkgs) atuin; };
    };
  };
}
