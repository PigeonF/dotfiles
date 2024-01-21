{pkgs, ...}: {
  imports = [
    ../../../modules/shell/atuin
    ../../../modules/shell/bat
    ../../../modules/shell/direnv
    ../../../modules/shell/erdtree
    ../../../modules/shell/ghq
    ../../../modules/shell/git
    ../../../modules/shell/helix
    ../../../modules/shell/nix
    ../../../modules/shell/starship
    ../../../modules/shell/zoxide
    ../../../modules/shell/zsh
  ];

  home = {
    packages = with pkgs; [
      just
      rustup
      vim
    ];

    shellAliases = {
      g = "git";
      c = "cargo";
    };
  };
}
