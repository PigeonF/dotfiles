local wezterm = require "wezterm"
local config = wezterm.config_builder()
config:set_strict_mode(true)

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("JetBrainsMono NFM")
config.font_size = 17

config.launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "pwsh.exe", "-NoLogo" }
    config.default_cwd = "D:\\"
    table.insert(config.launch_menu, { label = "PowerShell", args = {"pwsh.exe", "-NoLogo"}, cwd = "D:\\" })
end

config.use_fancy_tab_bar = false

return config
