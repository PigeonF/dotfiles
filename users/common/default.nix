{
  inputs,
  pkgs,
  stateVersion,
  ...
}:
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

  manual = {
    html.enable = false;
    manpages.enable = false;
    json.enable = false;
  };

  programs.home-manager.enable = true;

  home = {
    inherit stateVersion;

    packages = builtins.attrValues {
      inherit (pkgs)
        committed
        crane
        diffoscopeMinimal
        dive
        dprint
        gh
        gitlab-ci-local
        glab
        lldb
        nil
        nixfmt-rfc-style
        regctl
        rustup
        shfmt
        skopeo
        sops
        ;
    };

    shellAliases = {
      g = "git";
      c = "cargo";
    };

    sessionPath = [
      "$XDG_BIN_HOME"
      "$CARGO_HOME/bin"
    ];

    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      XDG_BIN_HOME = "$HOME/.local/bin";

      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      DOCKER_CONFIG = "${XDG_DATA_HOME}/docker";
      GOPATH = "${XDG_DATA_HOME}/go";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";

      HISTFILE = "${XDG_STATE_HOME}/bash_history.txt";

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
