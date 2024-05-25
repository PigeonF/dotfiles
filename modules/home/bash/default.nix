{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.bash;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.bash = {
    enable = mkEnableOption "PigeonF Bash Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues {
        inherit (pkgs)
          bashInteractive
          eza
          fd
          ripgrep
          shellcheck
          shfmt
          ;
      };
    };
  };
}
