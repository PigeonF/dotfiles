{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/shell/git
    ../../modules/shell/zsh
    ../../modules/shell/starship
    ../../modules/shell/nix
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
