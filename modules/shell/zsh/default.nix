{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.cacheHome}/zsh_history.txt";

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
