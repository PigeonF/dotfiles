{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/shell/git
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
