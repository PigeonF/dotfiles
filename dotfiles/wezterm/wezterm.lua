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

config.leader = { key = 'a', mods = 'CTRL' }
config.disable_default_key_bindings = true
config.keys = {
  { key = 'P', mods = 'CTRL', action = wezterm.action.ActivateCommandPalette },

  { key = 'a', mods = 'LEADER|CTRL', action = wezterm.action { SendString = '\x01' } },
  { key = '-', mods = 'LEADER', action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } } },
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } } },
  { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },
  { key = 'c', mods = 'LEADER', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Left' } },
  { key = 'j', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Down' } },
  { key = 'k', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Up' } },
  { key = 'l', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Right' } },
  { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
  { key = 'J', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
  { key = 'K', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
  { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },
  { key = '1', mods = 'LEADER', action = wezterm.action { ActivateTab = 0 } },
  { key = '2', mods = 'LEADER', action = wezterm.action { ActivateTab = 1 } },
  { key = '3', mods = 'LEADER', action = wezterm.action { ActivateTab = 2 } },
  { key = '4', mods = 'LEADER', action = wezterm.action { ActivateTab = 3 } },
  { key = '5', mods = 'LEADER', action = wezterm.action { ActivateTab = 4 } },
  { key = '6', mods = 'LEADER', action = wezterm.action { ActivateTab = 5 } },
  { key = '7', mods = 'LEADER', action = wezterm.action { ActivateTab = 6 } },
  { key = '8', mods = 'LEADER', action = wezterm.action { ActivateTab = 7 } },
  { key = '9', mods = 'LEADER', action = wezterm.action { ActivateTab = 8 } },
  { key = '&', mods = 'LEADER|SHIFT', action = wezterm.action { CloseCurrentTab = { confirm = true } } },
  { key = 'x', mods = 'LEADER', action = wezterm.action { CloseCurrentPane = { confirm = true } } },
  { key = 'r', mods = 'LEADER', action = wezterm.action.ReloadConfiguration },

  { key = 'n', mods = 'SHIFT|CTRL', action = 'ToggleFullScreen' },
  { key = 'v', mods = 'SHIFT|CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'c', mods = 'SHIFT|CTRL', action = wezterm.action.CopyTo 'Clipboard' },

  { key = '+', mods = 'CTRL', action = 'IncreaseFontSize' },
  { key = '-', mods = 'CTRL', action = 'DecreaseFontSize' },
  { key = '0', mods = 'CTRL', action = 'ResetFontSize' },
}

return config
