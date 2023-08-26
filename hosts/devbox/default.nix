{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/shell/atuin
    ../../modules/shell/bat
    ../../modules/shell/direnv
    ../../modules/shell/erdtree
    ../../modules/shell/ghq
    ../../modules/shell/git
    ../../modules/shell/nix
    ../../modules/shell/starship
    ../../modules/shell/zoxide
    ../../modules/shell/zsh
  ];

  home = {
    packages = with pkgs; [
      vim
      just
    ];

    shellAliases = {
      g = "git";
    };
  };
}
