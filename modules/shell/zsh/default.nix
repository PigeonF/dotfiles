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
