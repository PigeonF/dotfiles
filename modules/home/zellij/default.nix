{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.zellij;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.zellij = {
    enable = mkEnableOption "PigeonF Zellij Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues { inherit (pkgs) zellij; };
    };
  };
}
