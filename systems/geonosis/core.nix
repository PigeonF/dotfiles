{ inputs, pkgs, ... }:
{
  time = {
    timeZone = "Europe/Berlin";
  };
  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  };

  environment = {
    enableAllTerminfo = true;
    systemPackages = [ pkgs.glibcLocales ];
    localBinInPath = true;
  };

  i18n = {
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_COLLATE = "C";
      LC_TIME = "en_DK.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
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