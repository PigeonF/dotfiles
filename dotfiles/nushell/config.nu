# Downloaded in env.nu
if ($env.NU_SCRIPTS_CACHE | path join "default_config.nu" | path exists) {
    source default_config.nu
}

let custom_config = {
    show_banner: false
    # https://github.com/microsoft/terminal/issues/13710
    # https://github.com/wez/wezterm/issues/2779
    # https://github.com/nushell/nushell/issues/6214
    shell_integration: false
}

$env.config = ($env.config | merge $custom_config)

# These are written in env.nu
# Load them last, since they might modify $env.config
if ($env.NU_SCRIPTS_CACHE | path join "atuin.nu" | path exists) {
    source atuin.nu
}

if ($env.NU_SCRIPTS_CACHE | path join "starship.nu" | path exists) {
    source starship.nu
}

if ($env.NU_SCRIPTS_CACHE | path join "zoxide.nu" | path exists) {
    source zoxide.nu
}
