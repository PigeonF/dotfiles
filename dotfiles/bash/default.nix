{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;

    historyFile = "${config.xdg.cacheHome}/bash_history.txt";
    historyIgnore = [
      "ls"
      "exit"
    ];

    shellAliases = {
      ls = "eza";
      la = "ls -la";

      fda = "fd --no-ignore --hidden";
      rga = "rg --no-ignore --hidden";
    };
  };

  home = {
    packages = builtins.attrValues { inherit (pkgs) eza fd ripgrep; };
  };
}
