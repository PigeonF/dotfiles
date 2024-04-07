{ pkgs, ... }:

{
  home.packages = [ pkgs.erdtree ];

  xdg.configFile."erdtree/.erdtreerc".source = ../../dotfiles/erdtree/config;
}
