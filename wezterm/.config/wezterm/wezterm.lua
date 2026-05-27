local wezterm = require "wezterm"
local config = wezterm.config_builder()
config:set_strict_mode(true)

-- Color Scheme
config.color_scheme = "Catppuccin Macchiato"
local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
-- Bright green is unreadable with white text
scheme.ansi[3] = "#8FBA84"
config.colors = scheme

-- Font
config.font = wezterm.font("JetBrainsMono NFM")
config.font_size = 13

-- Launch Menu
config.launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "pwsh.exe", "-NoLogo", "-NoExit", "-Command", "& 'C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\Launch-VsDevShell.ps1'" }
    config.default_cwd = "D:\\"
    table.insert(config.launch_menu, { label = "PowerShell", args = {"pwsh.exe", "-NoLogo"}, cwd = "D:\\" })
end

-- Tab Bar
config.use_fancy_tab_bar = false
config.tab_max_width = 21
config.hide_tab_bar_if_only_one_tab = true

-- Other
config.audible_bell = "Disabled"
config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor',
}

return config
