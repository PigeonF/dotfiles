$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand -n }
        to_string: { |v| $v | path expand -n | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand -n }
        to_string: { |v| $v | path expand -n | str join (char esep) }
    }
}

$env.NU_CACHED_SCRIPTS_DIR = ($env.XDG_CACHE_HOME? | default ($nu.home-path | path join ".cache") | path join 'nushell' 'scripts')
$env.NU_LIB_DIRS = [
    $env.NU_CACHED_SCRIPTS_DIR
    ($nu.config-path | path dirname | path join 'scripts')
]

$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

$env.DEFAULT_CONFIG_FILE = ($env.NU_CACHED_SCRIPTS_DIR | path join "default_config.nu")
$env.ATUIN_CONFIG_FILE = ($env.NU_CACHED_SCRIPTS_DIR | path join "atuin.nu")
$env.STARSHIP_CONFIG_FILE = ($env.NU_CACHED_SCRIPTS_DIR | path join "starship.nu")
$env.ZOXIDE_CONFIG_FILE = ($env.NU_CACHED_SCRIPTS_DIR | path join "zoxide.nu")

def "pigeonf dotfiles now" [] {
    date now | format date "%Y-%m-%dT%H:%M:%S%.3f"
}

def "pigeonf dotfiles download nu" [local: path, remote: string] {
    let version = (nu --version)
    let remote = (
        $"https://raw.githubusercontent.com/nushell/nushell/($version)/($remote)"
    )

    let local = ($local | path expand)
    mkdir ($local | path dirname)

    if ($local | path exists) {
        let new = (http get $remote)
        let old = (open $local)

        if $old != $new {
            $new | save --force $local
            print --stderr $"(ansi white)INF|(pigeonf dotfiles now)|Updated ($local)(ansi reset)"
        } else {
            print --stderr $"(ansi white)INF|(pigeonf dotfiles now)|No changes in ($local)(ansi reset)"
        }
    } else {
        http get $remote | save --force $local
        print --stderr $"(ansi white)INF|(pigeonf dotfiles now)|Downloaded ($local)(ansi reset)"
    }
}

export def "config update default" [ --help (-h) ] {
    pigeonf dotfiles download nu $env.DEFAULT_CONFIG_FILE "crates/nu-utils/src/sample_config/default_config.nu"
}

if not ($env.DEFAULT_CONFIG_FILE | path exists) {
    print --stderr $"(ansi yellow)WRN|(pigeonf dotfiles now)|($env.DEFAULT_CONFIG_FILE) does not exist(ansi reset)"
    config update default
}

if not ($env.ATUIN_CONFIG_FILE | path exists) {
    mkdir ($env.ATUIN_CONFIG_FILE | path dirname)
    atuin init --disable-up-arrow nu | save --force $env.ATUIN_CONFIG_FILE
}

if not ($env.STARSHIP_CONFIG_FILE | path exists) {
    mkdir ($env.STARSHIP_CONFIG_FILE | path dirname)
    starship init nu | save --force $env.STARSHIP_CONFIG_FILE
}

if not ($env.ZOXIDE_CONFIG_FILE | path exists) {
    mkdir ($env.ZOXIDE_CONFIG_FILE | path dirname)
    # https://github.com/ajeetdsouza/zoxide/pull/663
    zoxide init nushell | str replace "-- $rest" "-- ...$rest" | save --force $env.ZOXIDE_CONFIG_FILE
}
