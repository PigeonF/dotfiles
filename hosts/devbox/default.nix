{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/shell/atuin
    ../../modules/shell/bash
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
      act
      gdb
      just
      lldb
      nodejs
      rr
      rustup
      valgrind
      vim
    ];

    sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" ];
    sessionVariables = {
      JUST_UNSTABLE = "1";
    };

    shellAliases = {
      c = "cargo";
      g = "git";
    };
  };
}
