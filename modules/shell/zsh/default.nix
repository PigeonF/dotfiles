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

      # Workaround for non NixOS systems that re-set PATH in /etc/zprofile
      # https://github.com/nix-community/home-manager/issues/2991#issuecomment-1141980642
      __HM_SESS_VARS_SOURCED= source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
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
