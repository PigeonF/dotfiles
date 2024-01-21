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

    packages = with pkgs; [
      alejandra
      nil
      glab
      hub
      lldb
      rustup
    ];

    shellAliases = {
      g = "git";
      c = "cargo";
    };

    sessionPath = ["$HOME/.local/bin" "$HOME/.cargo/bin"];
  };
}
