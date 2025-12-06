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
    programs = {
      helix = {
        enable = true;
      };
    };
  };
  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.11";
    packages = [ pkgs.ncurses ];
  };
  news = {
    display = "silent";
  };
}
