{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.fzf;
in
{
  _file = ./fzf.nix;

  options.dotfiles.programs = {
    fzf = {
      enable = mkEnableOption "set up fzf";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        fzf = {
          inherit (cfg) enable;
          # Catppuccin Macchiato from https://github.com/catppuccin/fzf
          colors = {
            "bg+" = "#363A4F";
            "bg" = "#24273A";
            "spinner" = "#F4DBD6";
            "hl" = "#ED8796";
            "fg" = "#CAD3F5";
            "header" = "#ED8796";
            "info" = "#C6A0F6";
            "pointer" = "#F4DBD6";
            "marker" = "#B7BDF8";
            "fg+" = "#CAD3F5";
            "prompt" = "#C6A0F6";
            "hl+" = "#ED8796";
            "selected-bg" = "#494D64";
            "border" = "#6E738D";
            "label" = "#CAD3F5";
          };
        };
      };
    }
  ];
}
