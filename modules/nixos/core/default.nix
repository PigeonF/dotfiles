{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.pigeonf.core;
  inherit (lib) mkDefault;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.core = {
      enable = lib.mkEnableOption "default core configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      tmp.useTmpfs = mkDefault true;

      initrd.systemd.enable = mkDefault true;
    };

    time = {
      timeZone = mkDefault "Europe/Berlin";
    };

    system = {
      configurationRevision = mkDefault (inputs.self.rev or inputs.self.dirtyRev or null);
      switch = {
        enable = mkDefault false;
        enableNg = mkDefault true;
      };
    };

    environment = {
      enableAllTerminfo = mkDefault true;
      systemPackages = [ pkgs.glibcLocales ];
      localBinInPath = mkDefault true;
    };

    i18n = {
      supportedLocales = [
        "C.UTF-8/UTF-8"
        "de_DE.UTF-8/UTF-8"
        "en_DK.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];

      extraLocaleSettings = {
        LC_COLLATE = mkDefault "C";
        LC_TIME = mkDefault "en_DK.UTF-8";
        LC_MONETARY = mkDefault "de_DE.UTF-8";
        LC_MEASUREMENT = mkDefault "de_DE.UTF-8";
      };
    };

    programs.nix-ld.enable = mkDefault true;

    security.sudo.extraConfig = ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults:root,%wheel env_keep+=SSH_AUTH_SOCK
    '';

    services = {
      dbus.enable = mkDefault true;
      timesyncd.enable = mkDefault true;
      # Do not suspend when closing lid while being charged.
      logind.lidSwitchExternalPower = mkDefault "ignore";
      logrotate.checkConfig = mkDefault false;

      openssh = {
        enable = mkDefault true;
        openFirewall = mkDefault true;
        extraConfig = ''
          AcceptEnv LANG LANGUAGE LC_*
          AcceptEnv COLORTERM TERM TERM_*
          AcceptEnv WEZTERM_REMOTE_PANE
        '';
        settings = {
          Macs = [
            "hmac-sha2-512"
            "hmac-sha2-512-etm@openssh.com"
            "hmac-sha2-256-etm@openssh.com"
            "umac-128-etm@openssh.com"
          ];
        };
      };
    };
  };
}
