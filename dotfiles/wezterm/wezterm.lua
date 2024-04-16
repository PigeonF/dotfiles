local wezterm = require 'wezterm'
local shells = require 'shells'

local config = wezterm.config_builder()
shells.apply_to_config(config)

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

config.font = wezterm.font_with_fallback {
  'Cartograph CF',
  'PragmataPro Mono',
  'JetBrains Mono',
}

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true

config.window_close_confirmation = 'NeverPrompt'

config.term = 'wezterm'

return config
