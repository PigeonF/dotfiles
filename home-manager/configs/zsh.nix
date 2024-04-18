{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.stateHome}/zsh/zsh_history.txt";

    profileExtra = lib.optionalString pkgs.stdenv.isDarwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases = config.programs.bash.shellAliases // { };

    initExtra = ''
      bindkey -e
      bindkey '^[[1;5C' emacs-forward-word
      bindkey '^[[1;5D' emacs-backward-word
    '';
  };
}
