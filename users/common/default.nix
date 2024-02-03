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
        gitlab-ci-local
        glab
        hub
        lldb
        nil
        nixfmt-rfc-style
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

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
    sessionVariables = {
      GCL_EXTRA_HOST = "local-registry.gitlab.com:host-gateway";
      GCL_VOLUME = "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro";
    };
  };
}
