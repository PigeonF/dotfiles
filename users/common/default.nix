{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ../../dotfiles/atuin
    ../../dotfiles/bat
    ../../dotfiles/direnv
    ../../dotfiles/erdtree
    ../../dotfiles/ghq
    ../../dotfiles/git
    ../../dotfiles/helix
    ../../dotfiles/just
    ../../dotfiles/nix
    ../../dotfiles/starship
    ../../dotfiles/zoxide
    ../../dotfiles/zsh
  ];

  manual = {
    html.enable = false;
    manpages.enable = false;
    json.enable = false;
  };

  home = {
    inherit stateVersion;

    packages = builtins.attrValues {
      inherit
        (pkgs)
        alejandra
        committed
        dprint
        gitlab-ci-local
        glab
        hub
        lldb
        nil
        rustup
        shfmt
        ;
    };

    file.".gitlab-ci-local/variables.yml" = {
      text = ''
        ---
        global:
          CI_REGISTRY_USER: "nobody"
          CI_REGISTRY_PASSWORD: "nobody"
      '';
    };

    shellAliases = {
      g = "git";
      c = "cargo";
    };

    sessionPath = ["$HOME/.local/bin" "$HOME/.cargo/bin"];
  };
}
