{{#if (eq dotter.os "windows")}}

{{#if dotter.packages.spicetify}}
set CATPPUCCIN_THEME=%APPDATA%\spicetify\Themes\catppuccin
rmdir %APPDATA%\spicetify\Themes\catppuccin
{{/if}}

{{/fi}}
