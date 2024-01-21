{
  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
  };

  xdg.configFile."atuin/config.toml".source = ./atuin.toml;
}
