{ lib, ... }:

{
  flake.homeModules.configs =
    let
      contents = builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ];
    in
    lib.mapAttrs' (
      name: _: lib.nameValuePair (lib.strings.removeSuffix ".nix" name) (import ./${name})
    ) contents;

  # {
  #   atuin = import ./atuin.nix;
  #   bash = import ./bash.nix;
  #   bat = import ./bat.nix;
  #   containers = import ./containers.nix;
  #   direnv = import ./direnv.nix;
  #   erdtree = import ./erdtree.nix;
  #   ghq = import ./ghq.nix;
  #   git = import ./git.nix;
  #   gitlab-ci-local = import ./gitlab-ci-local;
  #   helix = import ./helix.nix;
  #   just = import ./just.nix;
  #   newsboat = import ./newsboat.nix;
  #   nix = import ./nix.nix;
  #   nushell = import ./nushell.nix;
  #   nvim = import ./nvim.nix;
  #   go = import ./go.nix;
  #   rust = import ./rust.nix;
  #   starship = import ./starship.nix;
  #   wezterm = import ./wezterm.nix;
  #   zellij = import ./zellij;
  #   zoxide = import ./zoxide.nix;
  #   zsh = import ./zsh.nix;
  # };
}
