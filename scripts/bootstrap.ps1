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

function Add-EnvPath([string] $path) {
    $persistedPaths = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User) -split ';'
    if ($persistedPaths -notcontains $path) {
        # Filter out empty lines with Where-Object
        $persistedPaths = $persistedPaths + $path | Where-Object { $_ }
        [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', [System.EnvironmentVariableTarget]::User)
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $path) {
        $envPaths = $envPaths + $path | Where-Object { $_ }
        $env:Path = $envPaths -join ';'
    }
}

function Initialize-Env([string]$variable, [string]$value) {
    if ($null -eq [Environment]::GetEnvironmentVariable($variable, [System.EnvironmentVariableTarget]::User)) {
        [Environment]::SetEnvironmentVariable($variable, $value, [System.EnvironmentVariableTarget]::User)
    }
    if (!(Test-Path "env:$variable")) {
        New-Item env:$variable -Value "$value" -Force | Out-Null
    }
}

function Set-Environment([Config]$config) {
    Initialize-Env "XDG_CONFIG_HOME" (Join-Path $config.developmentDrive "config")
    Initialize-Env "XDG_CACHE_HOME" (Join-Path $config.developmentDrive "cache")
    Initialize-Env "XDG_DATA_HOME" (Join-Path $config.developmentDrive "share")
    Initialize-Env "XDG_STATE_HOME" (Join-Path $config.developmentDrive "state")
    Initialize-Env "XDG_BIN_HOME" (Join-Path $config.developmentDrive "bin")
    Initialize-Env "STARSHIP_CONFIG" (Join-Path $env:XDG_CONFIG_HOME "starship.toml")

    Add-EnvPath($env:XDG_BIN_HOME)
}

function Update-Git-Repository([Config]$config) {
    $gitDir = "git\github.com\PigeonF\"
    $null = New-item -Path $config.developmentDrive -Name $gitDir -ItemType "directory" -Force
    $gitDir = Join-Path $config.developmentDrive $gitDir
    if (!(Test-Path (Join-Path $gitDir "dotfiles"))) {
        git clone git@github.com:PigeonF/dotfiles.git (Join-Path $gitDir "dotfiles")
    }
}

function Main([Config]$config) {
    Test-Drives $config
    Test-Winget

    Install-Base-Dependencies $config
    Set-Environment $config
    Write-Output "Do not forget to log in to 1Password and enable the SSH integration!"

    $null = Read-Host "1Password SSH integration is ready?"

    Update-Git-Repository $config

    Write-Output "Continue installation with"
    Write-Output "$($config.developmentDrive)\git\github.com\PigeonF\dotfiles\scripts\install-packages.ps1"
    Write-Output "$($config.developmentDrive)\git\github.com\PigeonF\dotfiles\dotfiles\symlink.ps1"
}

$config = [Config]::new()
$config.developmentDrive = "D:"

if ($Action -eq "Main") {
    Main $config
}
elseif ($Action -eq "OpenSSHFixup") {
    OpenSSHFixup
}
