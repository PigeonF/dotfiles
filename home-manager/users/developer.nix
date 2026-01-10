{ lib, pkgs, ... }:
let
  username = "developer";
in
{
  _file = ./developer.nix;

  dotfiles = {
    dotter = {
      enable = true;
      clone = {
        enable = true;
      };
    };
    presets = {
      containers = {
        enable = true;
      };
      shell = {
        enable = true;
      };
      programming = {
        enable = true;
      };
      rust = {
        enable = true;
      };
    };
    programs = {
      atuin.enable = true;
      bash.enable = true;
      bat.enable = true;
      btop.enable = true;
      eza.enable = true;
      fd.enable = true;
      fzf.enable = true;
      git.enable = true;
      ghq.enable = true;
      helix.enable = true;
      home-manager.enable = true;
      jujutsu.enable = true;
      nix.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      vivid.enable = true;
      yazi.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
    };
  };
  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.11";
  };
  news = {
    display = "silent";
  };
  nix = {
    settings = {
      # TODO(PigeonF): Figure out how to make this work in nspawn container
      sandbox = lib.mkForce false;
    };
  };
}
