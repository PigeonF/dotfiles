--- shells.lua - Configure the shells for wezterm

local wezterm = require("wezterm")

local M = {}

--- Configure the default shell and launch menu.
function M.apply_to_config(config)
    config.default_prog = { "nu", "-l" }

    config.launch_menu = {
        {
            label = "NuShell",
        },
    }

    if wezterm.target_triple == "x86_64-pc-windows-msvc" then
        table.insert(config.launch_menu, {
            label = "PowerShell",
            args = { "pwsh", "-NoLogo" },
        })
    end
end

return M
