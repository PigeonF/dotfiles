{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.presets.shell;
in
{
  _file = ./shell.nix;

  options.dotfiles.presets = {
    shell = {
      enable = mkEnableOption "set up default shell settings";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        extraOutputsToInstall = [ "man" ];

        packages = [
          pkgs.ncurses # Ensures that there are no missing DB files for any curses based programs
        ];

        preferXdgDirectories = true;
      };
      xdg = {
        enable = true;
      };
    })
    (lib.mkIf (cfg.enable && config.home.preferXdgDirectories) {
      # Most of these are from https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
      home = {
        sessionVariables = {
          CALCHISTFILE = "${config.xdg.stateHome}/calc_history";
          WGETRC = "${config.xdg.configHome}/wgetrc";
        };
      };
      xdg = {
        configFile = {
          wgetrc = {
            text = ''
              hosts-file = "${config.xdg.stateHome}/wget-hsts"
            '';
          };
        };
      };
    })
  ];
}
