{ pkgs, ... }: {
  home.packages = with pkgs; [
    erdtree
  ];

  xdg.configFile."erdtree/.erdtreerc".source = ./config;
}
