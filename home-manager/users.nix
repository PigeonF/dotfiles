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
        builtins.attrValues {
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
            # gitlab-ci-local
            helix
            just
            nix
            nushell
            nvim
            rust
            starship
            wezterm
            zellij
            zoxide
            zsh
            ;
        }
      );

      vagrant = mkUser "vagrant" (
        builtins.attrValues {
          inherit (inputs.self.homeModules) core xdg;

          inherit (inputs.self.homeModules.configs)
            bash
            git
            just
            starship
            wezterm
            zellij
            zoxide
            ;
        }
      );
    };
}
