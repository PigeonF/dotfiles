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
      gdb
      glab
      hub
      just
      lldb
      nodejs
      rr
      rustup
      valgrind
      vim
    ];

    file.".npmrc" = {
      text = ''
        prefix = $HOME/.npm
      '';
    };

    sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.npm/bin" ];
    sessionVariables = {
      JUST_UNSTABLE = "1";
    };

    shellAliases = {
      c = "cargo";
      g = "git";
    };
  };
}
