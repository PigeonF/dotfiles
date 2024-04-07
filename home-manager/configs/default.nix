{
  flake.homeModules.configs = {
    bash = import ./bash.nix;
    bat = import ./bat.nix;
    containers = import ./containers.nix;
    direnv = import ./direnv.nix;
    ghq = import ./ghq.nix;
    just = import ./just.nix;
    nix = import ./nix.nix;
    rust = import ./rust.nix;
    zellij = import ./zellij.nix;
    zoxide = import ./zoxide.nix;
    zsh = import ./zsh.nix;

    tools =
      { pkgs, ... }:
      {
        home.packages = builtins.attrValues {
          inherit (pkgs)
            # committed
            dprint
            gh
            # gitlab-ci-local
            glab
            lldb
            ;
        };
      };
  };
}
