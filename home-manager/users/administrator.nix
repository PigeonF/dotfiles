{ pkgs, ... }:
let
  username = "administrator";
in
{
  _file = ./administrator.nix;

  dotfiles = {
    dotter = {
      enable = true;
      clone = {
        enable = true;
      };
    };
    presets = {
      shell = {
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
      helix.enable = true;
      home-manager.enable = true;
      nix.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
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
}
