{ pkgs, config, lib, ... }:
with lib;
let
  inherit (pkgs) stdenv;
in
{
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.cacheHome}/zsh_history.txt";

    profileExtra = optionalString stdenv.isDarwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases = {
      ls = "eza";
      la = "ls -la";

      fda = "fd --no-ignore --hidden";
      rga = "rg --no-ignore --hidden";
    };

    initExtra = ''
      bindkey -e
      bindkey '^[[1;5C' emacs-forward-word
      bindkey '^[[1;5D' emacs-backward-word
    '';
  };

  home = {
    packages = with pkgs; [
      eza
      fd
      ripgrep
    ];
  };
}
