{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.eza;
in
{
  _file = ./eza.nix;

  options.dotfiles.programs = {
    eza = {
      enable = mkEnableOption "set up eza";
    };
  };

  config = lib.mkMerge [
    {
      programs.eza = {
        inherit (cfg) enable;
      };
    }
    (lib.mkIf cfg.enable {
      home = {
        shellAliases = {
          la = "eza --long --all";
          ls = "eza";
        };
      };
    })
  ];
}
