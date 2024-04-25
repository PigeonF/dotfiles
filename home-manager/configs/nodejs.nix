{ config, pkgs, ... }:

{
  home = {
    packages = [ pkgs.nodejs ];

    sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    };

    sessionPath = [ "$XDG_DATA_HOME/npm/bin" ];
  };

  xdg.configFile."npm/npmrc" = {
    text = ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      logs-dir=''${XDG_STATE_HOME}/npm/logs
    '';
  };
}
