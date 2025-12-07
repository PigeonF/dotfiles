{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.vivid;
in
{
  _file = ./vivid.nix;

  options.dotfiles.programs = {
    vivid = {
      enable = mkEnableOption "set up vivid";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        vivid = {
          inherit (cfg) enable;
          activeTheme = "catppuccin-macchiato";
        };
      };
    }
  ];
}
