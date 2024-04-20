# Downloaded in env.nu
source default_config.nu

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
source atuin.nu
source starship.nu
source zoxide.nu

overlay use nupm/ --prefix
