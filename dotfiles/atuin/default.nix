{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    # Already part of env.nu
    enableNushellIntegration = false;
  };

  xdg.configFile."atuin/config.toml".source = ./atuin.toml;
}
