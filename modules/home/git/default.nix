{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.git;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.git = {
    enable = mkEnableOption "PigeonF Git Packages";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        delta
        gh
        git-branchless
        git-lfs
        glab
        ;

      inherit (pkgs.gitAndTools) gitFull;
    };
  };
}
