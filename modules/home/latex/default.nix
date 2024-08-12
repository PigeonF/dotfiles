{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.latex;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.latex = {
    enable = mkEnableOption "PigeonF LaTeX Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-full latex-bin latexmk; }) ];
    };
  };
}
