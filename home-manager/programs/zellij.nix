{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.zellij;
in
{
  _file = ./zellij.nix;

  options.dotfiles.programs = {
    zellij = {
      enable = mkEnableOption "set up zellij";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        zellij = {
          inherit (cfg) enable;
          enableBashIntegration = false;
          enableFishIntegration = false;
          enableZshIntegration = false;
        };
      };
    }
  ];
}
