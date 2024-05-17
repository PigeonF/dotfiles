local wezterm = require 'wezterm'

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Macchiato'
  else
    return 'Catppuccin Latte'
  end
end

local config = wezterm.config_builder()

config.launch_menu = {
  {
    label = 'NuShell',
    args = { "nu", "-l" }
  },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(config.launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh', '-NoLogo' },
  })
end

config.color_scheme = scheme_for_appearance(get_appearance())

config.font = wezterm.font_with_fallback {
  'Fira Code',
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
  { key = 'v', mods = 'SHIFT|CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'c', mods = 'SHIFT|CTRL', action = wezterm.action.CopyTo 'Clipboard' },

  { key = '+', mods = 'CTRL', action = 'IncreaseFontSize' },
  { key = '-', mods = 'CTRL', action = 'DecreaseFontSize' },
  { key = '0', mods = 'CTRL', action = 'ResetFontSize' },
}

return config
