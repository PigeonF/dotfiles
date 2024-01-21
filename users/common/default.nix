{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ../../modules/shell/atuin
    ../../modules/shell/bat
    ../../modules/shell/direnv
    ../../modules/shell/erdtree
    ../../modules/shell/ghq
    ../../modules/shell/git
    ../../modules/shell/helix
    ../../modules/shell/just
    ../../modules/shell/nix
    ../../modules/shell/starship
    ../../modules/shell/zoxide
    ../../modules/shell/zsh
  ];

  manual = {
    html.enable = false;
    manpages.enable = false;
    json.enable = false;
  };

  home = {
    inherit stateVersion;

    packages = with pkgs; [
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
