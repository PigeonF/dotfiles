#Requires -Version 5

<#
.Synposis
    Symlink the configuration files
#>
param(
    [Parameter(Mandatory = $false)][switch]$Force
)

function HandleSymlink([string]$path, [string]$target) {
    if (Test-Path $path) {
        $file = Get-Item -LiteralPath $path
        $is_symlink = $file.LinkType -eq "HardLink" -or $file.LinkType -eq "SymbolicLink"
        if ($is_symlink) {
            $current_target = $file | Select-Object -ExpandProperty Target
            if ($current_target -ne $target) {
                New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                if ($?) { Write-Host "Symlink $path -> $target (Previously $current_target)" }
            }
            else {
                Write-Host "Symlink $path -> $target (Already exists)"
            }
        }
        else {
            if ($Force) {
                New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                if ($?) { Write-Host "Symlink $path -> $target (Forced)" }
            }
            else {
                Write-Error "Path: $path already exists"
            }
        }
    }
    else {
        $parent = [System.Io.Path]::GetDirectoryName($path)
        [System.Io.Directory]::CreateDirectory($parent) | Out-Null

        New-Item -ItemType SymbolicLink -Path "$path" -Target "$target" | Out-Null
        if ($?) { Write-Host "Symlink $path -> $target" }
    }
}

function Main() {
    $Root = (Get-Item $PSScriptRoot).Parent.FullName
    $DotfilesDir = Join-Path $Root dotfiles

    $XdgConfigHome = $env:XDG_CONFIG_HOME

    $SSHDirTarget = Join-Path $HOME .ssh

    # atuin
    $AtuinDirSource = Join-Path $DotfilesDir atuin
    $AtuinDirTarget = Join-Path $XdgConfigHome atuin
    HandleSymlink (Join-Path $AtuinDirTarget "config.toml") (Join-Path $AtuinDirSource "atuin.toml")

    # Erdtree
    $ErdTreeSource = Join-Path $DotfilesDir erdtree
    $ErdTreeTarget = Join-Path $env:APPDATA erdtree
    HandleSymlink (Join-Path $ErdTreeTarget ".erdtreerc") (Join-Path $ErdTreeSource "config")

    # Git
    $GitDirSource = Join-Path $DotfilesDir git
    $GitDirTarget = Join-Path $XdgConfigHome git
    HandleSymlink (Join-Path $GitDirTarget "config") (Join-Path $GitDirSource "gitconfig")
    HandleSymlink (Join-Path $GitDirTarget "ignore") (Join-Path $GitDirSource "gitignore")
    HandleSymlink (Join-Path $SSHDirTarget "allowed_signers") (Join-Path $GitDirSource "allowed_signers")

    # Helix
    $HelixDirSource = Join-Path $DotfilesDir helix
    $HelixDirTarget = Join-Path $env:SCOOP "persist\helix"
    HandleSymlink (Join-Path $HelixDirTarget "config.toml") (Join-Path $HelixDirSource "config.toml")

    # NeoVim
    $NeoVimDirSource = Join-Path $DotfilesDir nvim
    $NeoVimDirTarget = Join-Path $XdgConfigHome nvim
    HandleSymlink (Join-Path $NeoVimDirTarget "init.lua") (Join-Path $NeoVimDirSource "init.lua")
    HandleSymlink (Join-Path $NeoVimDirTarget "lua") (Join-Path $NeoVimDirSource "lua")
    HandleSymlink (Join-Path $NeoVimDirTarget "lazy-lock.json") (Join-Path $NeoVimDirSource "lazy-lock.json")

    # Nushell
    $NuDirSource = Join-Path $DotfilesDir nushell
    $NuDirTarget = Join-Path $XdgConfigHome nushell
    HandleSymlink (Join-Path $NuDirTarget "config.nu") (Join-Path $NuDirSource "config.nu")
    HandleSymlink (Join-Path $NuDirTarget "env.nu") (Join-Path $NuDirSource "env.nu")
    HandleSymlink (Join-Path $NuDirTarget "login.nu") (Join-Path $NuDirSource "login.nu")

    # Starship
    $StarshipDirSource = Join-Path $DotfilesDir starship
    $StarshipDirTarget = $XdgConfigHome
    HandleSymlink (Join-Path $StarshipDirTarget "starship.toml") (Join-Path $StarshipDirSource "starship.toml")

    # Topgrade
    $TopgradeDirSource = Join-Path $DotfilesDir topgrade
    $TopgradeDirTarget = $env:APPDATA
    HandleSymlink (Join-Path $TopgradeDirTarget "topgrade.toml") (Join-Path $TopgradeDirSource "topgrade.toml")

    # VS Code
    $CodeDirSource = Join-Path $DotfilesDir vscode
    $CodeDirTarget = Join-Path $env:SCOOP "persist\vscode\data\user-data\User\"
    HandleSymlink (Join-Path $CodeDirTarget "settings.json") (Join-Path $CodeDirSource "settings.json")

    # Wezterm
    $WeztermDirSource = Join-Path $DotfilesDir wezterm
    $WeztermDirTarget = Join-Path $XdgConfigHome wezterm
    HandleSymlink (Join-Path $WeztermDirTarget "wezterm.lua") (Join-Path $WeztermDirSource "wezterm.lua")
    HandleSymlink (Join-Path $WeztermDirTarget "shells.lua") (Join-Path $WeztermDirSource "shells.lua")
}

Main
