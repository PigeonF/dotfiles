{ inputs, pkgs, ... }:
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
    packages = builtins.attrValues {
      inherit (pkgs)
        # committed
        crane
        diffoscopeMinimal
        dive
        dprint
        gh
        # gitlab-ci-local
        glab
        lldb
        nil
        nixfmt-rfc-style
        regctl
        shfmt
        skopeo
        sops
        ;
    };

    shellAliases = {
      g = "git";
    };

    sessionPath = [ "$GOPATH/bin" ];

    sessionVariables = {
      DOCKER_CONFIG = "$XDG_DATA_HOME/docker";
      GOPATH = "$XDG_DATA_HOME/go";

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
