{
  inputs,
  pkgs,
  stateVersion,
  ...
}:
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
        crane
        diffoscopeMinimal
        dive
        dprint
        glab
        hub
        lldb
        nil
        nixfmt-rfc-style
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
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
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
