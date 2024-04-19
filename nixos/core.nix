_:

{
  flake.nixosModules = {
    core =
      { inputs, lib, ... }:
      {
        time = {
          timeZone = lib.mkDefault "Europe/Berlin";
        };

        system = {
          configurationRevision = lib.mkDefault (inputs.self.rev or inputs.self.dirtyRev or null);
        };
      };

    coreLinux =
      { pkgs, ... }:
      {
        environment = {
          enableAllTerminfo = true;
          systemPackages = [ pkgs.glibcLocales ];
        };

        services.dbus.enable = true;
        services.timesyncd.enable = true;

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
      };
  };
}
