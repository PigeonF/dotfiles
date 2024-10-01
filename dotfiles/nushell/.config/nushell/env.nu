export-env {
    let esep_path_converter = {
        from_string: { |s| $s | split row (char esep) | path expand -n }
        to_string: { |v| $v | path expand -n | str join (char esep) }
    }

    load-env {
        ENV_CONVERSIONS: {
            "PATH": $esep_path_converter
            "Path": $esep_path_converter
        }
    }
}

def with-env-defaults [defaults: record] nothing -> record {
    $defaults
    | transpose key value
    | reduce -f [] {|it, acc|
    let value = if ($it.key in $env) { $env | get $it.key } else { $it.value }
        $acc | append [[key value]; [$it.key $value]]
    }
    | transpose -i -r -d
}

def is-windows? []: nothing -> bool {
    ($nu.os-info | get family) == "windows"
}

if (is-windows?) {
    export-env { load-env (with-env-defaults {
        XDG_CACHE_HOME: ($nu.home-path | path join "AppData" "Local" "Cache")
        XDG_CONFIG_HOME: ($nu.home-path | path join "AppData" "Roaming")
        XDG_DATA_HOME: ($nu.home-path | path join "AppData" "Local" "Data")
        XDG_STATE_HOME: ($nu.home-path | path join "AppData" "Local" "State")
        XDG_BIN_HOME: ($nu.home-path | path join "bin")
    }) }
} else {
    export-env { load-env (with-env-defaults {
        XDG_CACHE_HOME: ($nu.home-path | path join ".cache")
        XDG_CONFIG_HOME: ($nu.home-path | path join ".config")
        XDG_DATA_HOME: ($nu.home-path | path join ".local" "share")
        XDG_STATE_HOME: ($nu.home-path | path join ".local" "state")
        XDG_BIN_HOME: ($nu.home-path | path join ".local" "bin")
    }) }
}

export-env { load-env (with-env-defaults {
    CARGO_HOME: ($env.XDG_DATA_HOME | path join "cargo")
    DOCKER_CONFIG: ($env.XDG_DATA_HOME | path join "docker")
    GOPATH: ($env.XDG_DATA_HOME | path join "go")
    NU_SCRIPTS_CACHE: ($env.XDG_CACHE_HOME | path join "nushell" "scripts")
    NU_SCRIPTS_CACHE_FALLBACK: ($env.XDG_CACHE_HOME | path join "nushell" "scripts" "fallbacks")
    NUPM_CACHE: ($env.XDG_CACHE_HOME | path join "nupm")
    NUPM_HOME: ($env.XDG_DATA_HOME | path join "nupm")
    RUSTUP_HOME: ($env.XDG_DATA_HOME | path join "rustup")
}) }

$env.NU_LIB_DIRS = [
    ($env.NUPM_HOME | path join "modules")
    ($env.NU_SCRIPTS_CACHE)
    ($env.NU_SCRIPTS_CACHE_FALLBACK)
]

$env.NU_PLUGIN_DIRS = [
    ($env.CARGO_HOME | path join "bin")
    ($env.NUPM_HOME | path join "plugins/bin")
]

use std ["path add"]

path add /nix/var/nix/profiles/default/bin
path add ($env.CARGO_HOME | path join "bin")
path add ($env.GOPATH | path join "bin")
path add ($env.NUPM_HOME | path join "scripts")
path add ($env.XDG_STATE_HOME | path join "nix/profile/bin")
path add $env.XDG_BIN_HOME

if (is-windows?) {
    $env.Path = ($env.Path | uniq)
    $env.EDITOR = 'nvim'
} else {
    $env.PATH = ($env.PATH | uniq)
}

$env.SHELL = $nu.current-exe

if not ($env.NU_SCRIPTS_CACHE | path exists) {
    mkdir $env.NU_SCRIPTS_CACHE
}

if not ($env.NU_SCRIPTS_CACHE_FALLBACK | path exists) {
    mkdir $env.NU_SCRIPTS_CACHE_FALLBACK
}

let default_config = $env.NU_SCRIPTS_CACHE | path join "default_config.nu"
if not ($default_config | path exists) {
    let version = (nu --version)
    let file = "crates/nu-utils/src/sample_config/default_config.nu"
    let remote = $"https://raw.githubusercontent.com/nushell/nushell/($version)/($file)"
    http get $remote | save --force $default_config
}

def has-binary? [binary: string]: nothing -> bool {
    not (which $binary | is-empty)
}

def ensure-command-completion [
    command: string,
    --shell: string,
    ...args: string
]: nothing -> nothing {
    let cache = $env.NU_SCRIPTS_CACHE | path join $"($command).nu"
    if not ($cache | path exists) {
        if (has-binary? $command) {
            let shell = $shell | default "nu"
            ^$command init ...$args $shell | save --force $cache
        } else {
            # Make sure the `source` in config.nu does not fail
            echo "" | save --force ($env.NU_SCRIPTS_CACHE_FALLBACK | path join $"($command).nu")
        }
    }
}

ensure-command-completion atuin "--disable-up-arrow"
ensure-command-completion starship
ensure-command-completion zoxide --shell nushell

if not ($env.NUPM_HOME | path join "modules" "nupm" | path exists) {
    let dir = mktemp -d
    git clone https://github.com/nushell/nupm ($dir)
    ^$nu.current-exe ...[
        --no-config-file
        --no-history
        --commands $"
            use ($dir | path join 'nupm')
            nupm install --force --path ($dir)
        "
    ]
}
