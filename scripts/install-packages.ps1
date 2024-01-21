#Requires -Version 5

<#
.Synposis
    Install packages
#>

class Config {
    [ValidateNotNullOrEmpty()][string]$developmentDrive
}

function Install-Packages-Winget([Config]$config) {
    # General Purpose
    winget install -e --id calibre.calibre
    winget install -e --id DigitalScholar.Zotero
    winget install -e --id Discord.Discord
    winget install -e --id dotPDNLLC.paintdotnet
    winget install -e --id Dropbox.Dropbox
    winget install -e --id flux.flux
    winget install -e --id Mozilla.Firefox
    winget install -e --id Mozilla.Thunderbird
    winget install -e --id MyPaint.MyPaint
    winget install -e --id Xournal++.Xournal++

    # Development
    $programDir = Join-Path $config.developmentDrive "programs"

    # C/C++
    winget install -e --id Microsoft.VisualStudio.2022.Community --override "--passive --norestart --wait --installPath \`"$(Join-Path $programDir "Visual Studio Community 2022")\`" --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 Microsoft.VisualStudio.Component.VC.ATL Microsoft.VisualStudio.Component.Windows11SDK.22000 Microsoft.VisualStudio.Component.SecurityIssueAnalysis Microsoft.VisualStudio.Component.Debugger.JustInTime Microsoft.VisualStudio.Component.IntelliCode Microsoft.VisualStudio.Component.VC.DiagnosticTools Microsoft.VisualStudio.Component.VC.TestAdapterForBoostTest Microsoft.VisualStudio.Component.VC.TestAdapterForGoogleTest Microsoft.VisualStudio.Component.VC.ASAN"
    winget install Microsoft.WinDbg
}

function Install-Packages-Scoop([Config]$config) {
    scoop bucket add extras
    scoop bucket add nerd-fonts

    # Prefer scoop until https://github.com/microsoft/winget-cli/issues/1002 is fixed
    scoop install slack zulip

    # C/C++
    scoop install meson cmake ninja llvm

    # Rust
    scoop install rustup
    cargo install cargo-binstall

    # General
    scoop install git-lfs uutils-coreutils
    scoop install zstd
    scoop install bat erdtree fd fzf just mdcat ripgrep topgrade
    scoop install JetBrainsMono-NF
    cargo binstall -y cargo-update

    #
    # Packages with dotfiles
    #

    # Git
    scoop install delta ghq meld
    $env:GHQ_ROOT = Join-Path $config.developmentDrive "git"
    [Environment]::SetEnvironmentVariable("GHQ_ROOT", $env:GHQ_ROOT, [System.EnvironmentVariableTarget]::User)

    # Nu Shell
    scoop install nu starship zoxide
    cargo binstall -y atuin

    # VS Code
    scoop install vscode

    # Wezterm
    scoop install wezterm
}

function Install-Packages([Config]$config) {
    Install-Packages-Winget $config
    Install-Packages-Scoop $config
}

$config = [Config]::new()
$config.developmentDrive = "D:"

Install-Packages $config
