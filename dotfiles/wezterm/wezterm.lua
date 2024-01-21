local wezterm = require("wezterm")
local shells = require("shells")

local config = wezterm.config_builder()

shells.apply_to_config(config)

config.color_scheme = "nord"

config.font = wezterm.font_with_fallback({
    "Cartograph CF",
    "PragmataPro Mono",
    "JetBrains Mono",
})

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true

config.window_close_confirmation = "NeverPrompt"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.prefer_egl = false
end

return config
