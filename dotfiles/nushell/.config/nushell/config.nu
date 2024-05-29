# Downloaded in env.nu
source default_config.nu

let custom_config = {
    show_banner: false
}

$env.config = ($env.config | merge $custom_config)

# These are written in env.nu
# Load them last, since they might modify $env.config
source atuin.nu
source starship.nu
source zoxide.nu

overlay use nupm/ --prefix
