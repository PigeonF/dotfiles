{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.python;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.python = {
    enable = mkEnableOption "PigeonF Python Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = (builtins.attrValues { inherit (pkgs) uv pipx; }) ++ [
        (pkgs.hiPrio pkgs.gcc)
        (pkgs.python312.withPackages (ppkgs: builtins.attrValues { inherit (ppkgs) nox virtualenv; }))
      ];
    };
  };
}
