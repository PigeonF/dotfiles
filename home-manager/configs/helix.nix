_:

{
  programs.helix = {
    enable = true;
    # defaultEditor = true;
  };

  xdg.configFile."helix/config.toml".source = ../../dotfiles/helix/config.toml;
}
