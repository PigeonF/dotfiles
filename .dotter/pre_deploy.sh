{{#if (eq dotter.os "windows")}}

{{#if dotter.packages.spicetify}}
ghq get -p github.com/catppuccin/spicetify
set CATPPUCCIN_THEME=%APPDATA%\spicetify\Themes\catppuccin
if not exist %CATPPUCCIN_THEME% (
    mklink /D "%CATPPUCCIN_THEME%" "D:\git\github.com\catppuccin\spicetify\catppuccin"
)
{{/if}}

{{/if}}
