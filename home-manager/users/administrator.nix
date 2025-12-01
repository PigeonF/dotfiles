{ pkgs, ... }:
let
  username = "administrator";
in
{
  _file = ./administrator.nix;

  home = {
    inherit username;
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.11";
    packages = [ pkgs.ncurses ];
  };
  news = {
    display = "silent";
  };
}
