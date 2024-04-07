{ inputs, ... }:
{
  imports = [
    ../../dotfiles/atuin
    ../../dotfiles/bash
    ../../dotfiles/bat
    ../../dotfiles/direnv
    ../../dotfiles/erdtree
    ../../dotfiles/ghq
    ../../dotfiles/git
    ../../dotfiles/helix
    ../../dotfiles/just
    ../../dotfiles/nix
    ../../dotfiles/nushell
    ../../dotfiles/starship
    ../../dotfiles/zellij
    ../../dotfiles/zoxide
    ../../dotfiles/zsh
  ];

  home = {
    shellAliases = {
      g = "git";
    };

    sessionVariables = {
      HISTFILE = "$XDG_STATE_HOME/bash_history.txt";
      GCL_ARTIFACTS_TO_SOURCE = "false";
    };
  };

  xdg.configFile."nixpkgs/config.nix" = {
    text = ''
      {
        packageOverrides = pkgs: {
          nur =
            import
              (builtins.fetchTarball {
                url = "${
                  inputs.nur.url or "https://github.com/nix-community/NUR/archive/${inputs.nur.rev}.tar.gz"
                }";
                sha256 = "${inputs.nur.narHash}";
              })
              { inherit pkgs; };
        };
      }
    '';
  };
}
