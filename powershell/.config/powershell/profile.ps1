function fdA { fd --hidden --no-ignore @args }
function fda { fd --hidden @args }
function g { git @args }
function jjj { jj --ignore-working-copy @args }
function l { eza --long --all --header @args }
function la { eza --long --all @args }
function ll { eza --long @args }
function lla { eza --long --all @args }
function lt { eza --tree @args }
function rgA { rg --hidden --no-ignore @args }
function rga { rg --hidden @args }
# Override builtin aliases
Set-Alias -Name cat -Value _cat
function _cat { bat --paging=never @args }
Set-Alias -Name ls -Value _ls
function _ls { eza @args }

function yy {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

if (Get-Command rg -errorAction SilentlyContinue) {
    Invoke-Expression (& { (rg --generate complete-powershell | Out-String) })
}

if (Get-Command starship -errorAction SilentlyContinue) {
    Invoke-Expression (& { (starship init powershell --print-full-init | Out-String) })
}

if (Get-Command zoxide -errorAction SilentlyContinue) {
     Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if (Get-Command vivid -errorAction SilentlyContinue) {
    $env:LS_COLORS = vivid generate catppuccin-macchiato
}
