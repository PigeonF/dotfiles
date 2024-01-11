{ inputs, pkgs, stateVersion, ... }:
{
  imports = [
    ../../modules/shell/atuin
    ../../modules/shell/bat
    ../../modules/shell/direnv
    ../../modules/shell/erdtree
    ../../modules/shell/ghq
    ../../modules/shell/git
    ../../modules/shell/helix
    ../../modules/shell/nix
    ../../modules/shell/starship
    ../../modules/shell/zoxide
    ../../modules/shell/zsh
  ];

  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

  home = {
    inherit stateVersion;

    packages = with pkgs; [
      just
      rustup
      vim
    ];

    shellAliases = {
      g = "git";
    };
  };
}
