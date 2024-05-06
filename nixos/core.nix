{ pkgs, ... }:
{
  environment = {
    enableAllTerminfo = true;
    systemPackages = [ pkgs.glibcLocales ];
    localBinInPath = true;
  };

  i18n = {
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_COLLATE = "C";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  programs.nix-ld.enable = true;

  security.sudo.extraConfig = ''
    Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
    Defaults:root,%wheel env_keep+=NIX_PATH
    Defaults:root,%wheel env_keep+=TERMINFO_DIRS
  '';

  services.dbus.enable = true;
  services.timesyncd.enable = true;
}
