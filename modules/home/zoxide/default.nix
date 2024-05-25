{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.zoxide;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.zoxide = {
    enable = mkEnableOption "PigeonF Zoxide Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues { inherit (pkgs) zoxide; };
    };
  };
}
