{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.ripgrep;
in
{
  _file = ./ripgrep.nix;

  options.dotfiles.programs = {
    ripgrep = {
      enable = mkEnableOption "set up ripgrep";
    };
  };

  config = lib.mkMerge [
    {
      programs.ripgrep = {
        inherit (cfg) enable;
      };
    }
    (lib.mkIf (cfg.enable && config.home.preferXdgDirectories) {
      home = {
        sessionVariables = {
          RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/ripgreprc";
        };
      };
    })
    (lib.mkIf cfg.enable {
      home = {
        shellAliases = {
          rgA = "rg --hidden --no-ignore";
          rga = "rg --hidden";
        };
      };
    })
  ];
}
