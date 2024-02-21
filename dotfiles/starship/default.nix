{
  programs.starship = {
    enable = true;
    # Already part of env.nu
    enableNushellIntegration = false;
  };

  xdg.configFile."starship.toml".source = ./starship.toml;
}
