{ inputs, lib, ... }:

{
  flake.homeModules.users =
    let
      mkUser =
        name: imports:
        { pkgs, ... }:
        {
          inherit imports;

          home = {
            username = lib.mkDefault name;
            homeDirectory = lib.mkDefault (if pkgs.stdenv.isDarwin then "/Users/${name}" else "/home/${name}");
            stateVersion = "24.05";
          };
        };
    in
    {
      pigeon = mkUser "pigeon" (

        (builtins.attrValues {
          inherit (inputs.self.homeModules) core xdg;

          inherit (inputs.self.homeModules.configs)
            atuin
            bash
            bat
            containers
            direnv
            erdtree
            ghq
            git
            gitlab-ci-local
            go
            helix
            just
            newsboat
            nix
            nodejs
            nushell
            nvim
            rust
            starship
            wezterm
            zellij
            zoxide
            zsh
            ;
        })
        ++ [
          (
            { pkgs, ... }:
            {
              home.packages = builtins.attrValues {
                inherit (pkgs)
                  committed
                  deadnix
                  dust
                  editorconfig-checker
                  fzf
                  gnumake
                  htop
                  jq
                  lemonade
                  markdownlint-cli2
                  nixfmt-rfc-style
                  pstree
                  reprotest
                  reuse
                  skim
                  statix
                  tree
                  typos
                  vale
                  watchexec
                  yamllint
                  ;
              };
            }
          )
        ]
      );

      vagrant = mkUser "vagrant" (
        builtins.attrValues {
          inherit (inputs.self.homeModules) core xdg;

          inherit (inputs.self.homeModules.configs)
            atuin
            bash
            git
            just
            nix
            starship
            wezterm
            zellij
            zoxide
            ;
        }
      );
    };
}
