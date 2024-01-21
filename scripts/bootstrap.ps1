#Requires -Version 5

<#
.Synposis
    Bootstrap the system
.Description
    Check that the system satisfies the assumptions (contains a D: drive as well as `winget`). Install
    `1Password`, `OpenSSH`, and `scoop`.

    Additionally, bootstrap the repository using `git`.
#>

param([string]$Action = "Main")

class Config {
    [ValidateNotNullOrEmpty()][string]$developmentDrive
}

function Test-Drives([Config]$config) {
    if (!(Test-Path $config.developmentDrive)) {
        throw [System.IO.FileNotFoundException] "No drive $($config.developmentDrive) found for development!"
    }

}

function Test-Winget() {
    if ($null -eq (Get-Command "winget.exe" -ErrorAction SilentlyContinue)) {
        throw [System.IO.FileNotFoundException] "Unable to find winget! Have you restarted your shell?"
    }
}

function OpenSSHFixup() {
    if ((Get-WindowsCapability -Online -Name "OpenSSH.Client~~~~0.0.1.0").State -eq 'Installed') {
        Remove-WindowsCapability -Online -Name "OpenSSH.Client~~~~0.0.1.0"
    }

    if ((Get-WindowsCapability -Online -Name "OpenSSH.Client~~~~0.0.1.0").State -eq 'Installed') {
        Remove-WindowsCapability -Online -Name "OpenSSH.Server~~~~0.0.1.0"
    }

    if (Get-Service "ssh-agent" -ErrorAction SilentlyContinue) {
        Stop-Service "ssh-agent"
        Set-Service "ssh-agent" -StartupType Disabled
    }
}

function Install-Base-Dependencies([Config] $config) {
    $programDir = "programs"

    $null = New-item -Path $config.developmentDrive -Name $programDir -ItemType "directory" -Force
    $null = New-item -Path $config.developmentDrive -Name "bin" -ItemType "directory" -Force

    # First, upgrade to ensure we have the latest version of winget.
    winget upgrade --all

    winget install -e --id Microsoft.PowerShell

    # TODO(PigeonF): It seems there is currently no way to change the install destination
    winget install -e --id Microsoft.OpenSSH.Beta
    # Remove Pre-Installed version of OpenSSH
    Start-Process -Wait powershell -Verb runAs -ArgumentList "$PSCommandPath -Action OpenSSHFixup"

    winget install -e --id AgileBits.1Password
    winget install -e --id AgileBits.1Password.CLI

    if ($null -eq (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
        $env:SCOOP = Join-Path $config.developmentDrive "scoop"
        [Environment]::SetEnvironmentVariable("SCOOP", $env:SCOOP, [System.EnvironmentVariableTarget]::User)
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    }

    scoop install 7zip
    scoop install mingit-busybox
    $env:GIT_SSH = (Get-Command ssh).source
    [Environment]::SetEnvironmentVariable("GIT_SSH", $env:GIT_SSH, [System.EnvironmentVariableTarget]::User)
}

function Set-Environment([Config]$config) {
    $xdgConfigHome = Join-Path $config.developmentDrive config
    $env:XDG_CONFIG_HOME = $xdgConfigHome
    [Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $env:XDG_CONFIG_HOME, [System.EnvironmentVariableTarget]::User)

    $xdgCacheHome = Join-Path $config.developmentDrive cache
    $env:XDG_CACHE_HOME = $xdgCacheHome
    [Environment]::SetEnvironmentVariable("XDG_CACHE_HOME", $env:XDG_CACHE_HOME, [System.EnvironmentVariableTarget]::User)

    $xdgDataHome = Join-Path $config.developmentDrive share
    $env:XDG_DATA_HOME = $xdgDataHome
    [Environment]::SetEnvironmentVariable("XDG_DATA_HOME", $env:XDG_DATA_HOME, [System.EnvironmentVariableTarget]::User)

    $xdgStateHome = Join-Path $config.developmentDrive state
    $env:XDG_STATE_HOME = $xdgStateHome
    [Environment]::SetEnvironmentVariable("XDG_STATE_HOME", $env:XDG_STATE_HOME, [System.EnvironmentVariableTarget]::User)

    $env:STARSHIP_CONFIG = Join-Path $env:XDG_CONFIG_HOME "starship.toml"
    [Environment]::SetEnvironmentVariable("STARSHIP_CONFIG", $env:STARSHIP_CONFIG, [System.EnvironmentVariableTarget]::User)

    $env:Path = $env:Path + ';' + (Join-Path $config.developmentDrive 'bin')
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User)
}

function Update-Git-Repository([Config]$config) {
    $gitDir = "git\github.com\PigeonF\"
    $null = New-item -Path $config.developmentDrive -Name $gitDir -ItemType "directory" -Force
    $gitDir = Join-Path $config.developmentDrive $gitDir
    git clone git@github.com:PigeonF/dotfiles.git (Join-Path $gitDir "dotfiles")
}

function Main([Config]$config) {
    Check-Drives $config
    Check-Winget

    Install-Base-Dependencies $config
    Set-Environment $config
    Write-Output "Do not forget to log in to 1Password and enable the SSH integration!"

    $null = Read-Host "1Password SSH integration is ready?"

    Update-Git-Repository $config

    Write-Output "Continue installation with"
    Write-Output "$($config.developmentDrive)\git\github.com\PigeonF\dotfiles\scripts\install-packages.ps1"
    Write-Output "$($config.developmentDrive)\git\github.com\PigeonF\dotfiles\scripts\symlink-dotfiles.ps1"
}

$config = [Config]::new()
$config.developmentDrive = "D:"

if ($Action -eq "Main") {
    Main $config
}
elseif ($Action -eq "OpenSSHFixup") {
    OpenSSHFixup
}
