{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.admintools;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.admintools = {
    enable = mkEnableOption "PigeonF Admintools Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues {
        inherit (pkgs)
          age
          lemonade
          lynx
          pstree
          sops
          ;
      };
    };
  };
}
