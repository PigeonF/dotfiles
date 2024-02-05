{ pkgs, stateVersion, ... }:
{
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
    ../../dotfiles/zellij
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
      inherit (pkgs)
        committed
        dprint
        glab
        hub
        lldb
        nil
        nixfmt-rfc-style
        rustup
        shfmt
        ;
    };

    shellAliases = {
      g = "git";
      c = "cargo";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
  };
}
