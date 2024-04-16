_:

{
  programs.wezterm = {
    enable = true;
  };

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ../../dotfiles/wezterm/wezterm.lua;
    "wezterm/shells.lua".source = ../../dotfiles/wezterm/shells.lua;
  };
}
