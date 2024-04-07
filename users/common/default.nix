{ inputs, ... }:
{
  imports = [
    ../../dotfiles/atuin
    ../../dotfiles/erdtree
    ../../dotfiles/git
    ../../dotfiles/helix
    ../../dotfiles/nushell
    ../../dotfiles/starship
  ];

  home = {
    shellAliases = {
      g = "git";
    };

    sessionVariables = {
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
