{ config, ... }:

{
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.stateHome}/zsh/zsh_history.txt";

    shellAliases = config.programs.bash.shellAliases // { };

    initExtra = ''
      bindkey -e
      bindkey '^[[1;5C' emacs-forward-word
      bindkey '^[[1;5D' emacs-backward-word
    '';
  };
}
