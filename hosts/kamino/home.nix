{ inputs, pkgs, ... }:
{
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
