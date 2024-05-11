{ config, ... }:

{
  programs.nushell = {
    enable = true;

    configFile.source = ../../dotfiles/nushell/config.nu;
    envFile.source = ../../dotfiles/nushell/env.nu;
    loginFile.source = ../../dotfiles/nushell/login.nu;
  };

  home.sessionVariables = {
    NUPM_HOME = "${config.xdg.dataHome}/nupm";
  };
}
