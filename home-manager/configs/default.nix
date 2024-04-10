{
  flake.homeModules.configs = {
    atuin = import ./atuin.nix;
    bash = import ./bash.nix;
    bat = import ./bat.nix;
    containers = import ./containers.nix;
    direnv = import ./direnv.nix;
    erdtree = import ./erdtree.nix;
    ghq = import ./ghq.nix;
    git = import ./git.nix;
    gitlab-ci-local = import ./gitlab-ci-local;
    helix = import ./helix.nix;
    just = import ./just.nix;
    nix = import ./nix.nix;
    nushell = import ./nushell.nix;
    nvim = import ./nvim.nix;
    rust = import ./rust.nix;
    starship = import ./starship.nix;
    zellij = import ./zellij.nix;
    zoxide = import ./zoxide.nix;
    zsh = import ./zsh.nix;
  };
}
