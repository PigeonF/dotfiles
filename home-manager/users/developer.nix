{ pkgs, ... }:
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
      c = {
        enable = true;
      };
      containers = {
        enable = true;
      };
      go = {
        enable = true;
      };
      programming = {
        enable = true;
      };
      python = {
        enable = true;
      };
      rust = {
        enable = true;
        cross = true;
        sccache = {
          enable = false;
        };
      };
      shell = {
        enable = true;
      };
      zig = {
        enable = true;
      };
    };
    programs = {
      atuin.enable = true;
      bash.enable = true;
      bat.enable = true;
      btop.enable = true;
      docker.enable = true;
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
    stateVersion = "26.05";
  };
  news = {
    display = "silent";
  };
}
