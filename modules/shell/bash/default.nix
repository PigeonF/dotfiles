{ pkgs, config, lib, ... }:
{
  programs.bash = {
    enable = true;

    historyFile = "${config.xdg.cacheHome}/bash_history.txt";
    historyIgnore = [
      "ls"
      "exit"
    ];

    shellAliases = {
      ls = "exa";
      la = "ls -la";

      fda = "fd --no-ignore --hidden";
      rga = "rg --no-ignore --hidden";
    };
  };

  home = {
    packages = with pkgs; [
      exa
      fd
      ripgrep
    ];
  };
}
