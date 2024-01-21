# These are downloaded in env.nu
source default_config.nu

let pre_prompt = if ($nu.os-info).family == "unix" {
    { ||
        let direnv = (direnv export json | from json)
        let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
        $direnv | load-env
    }
} else {
    { ||
        null
    }
}

let hooks = {
    pre_prompt: [$pre_prompt]
    pre_execution: [{||
        null  # replace with source code to run before the repl input is run
    }]
    env_change: {
        PWD: [{|before, after|
        null  # replace with source code to run if the PWD environment is different since the last repl input
        }]
    }
    display_output: {||
        if (term size).columns >= 100 { table -e } else { table }
    }
    command_not_found: {||
        null  # replace with source code to return an error message when a command is not found
    }
}

let custom_config = {
    show_banner: false
    # https://github.com/microsoft/terminal/issues/13710
    # https://github.com/wez/wezterm/issues/2779
    # https://github.com/nushell/nushell/issues/6214
    shell_integration: false
    hooks: $hooks
}

$env.config = ($env.config | merge $custom_config)

# These are written in env.nu
# Load them last, since they might modify $env.config
source atuin.nu
source starship.nu
source zoxide.nu
