_:

{
  programs.zellij = {
    enable = true;
    # Because of https://github.com/nix-community/home-manager/issues/4613, we
    # do not generate the configuration via nix.
  };

  xdg.configFile."zellij/config.kdl" = {
    source = ./config.kdl;
  };
}
