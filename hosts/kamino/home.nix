{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/shell/atuin
    ../../modules/shell/direnv
    ../../modules/shell/erdtree
    ../../modules/shell/git
    ../../modules/shell/nix
    ../../modules/shell/starship
    ../../modules/shell/zsh
  ];

  home = {
    stateVersion = "23.05";

    packages = with pkgs; [
      vim
      just
    ];

    shellAliases = {
      g = "git";
    };
  };
}
