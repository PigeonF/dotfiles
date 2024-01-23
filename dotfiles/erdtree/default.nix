{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit (pkgs) erdtree;
  };

  xdg.configFile."erdtree/.erdtreerc".source = ./config;
}
