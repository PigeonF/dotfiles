_:

{
  flake.nixosModules = {
    core =
      { inputs, lib, ... }:
      {
        time = {
          timeZone = lib.mkDefault "Europe/Berlin";
        };

        i18n = {
          supportedLocales = [
            "C.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
            "de_DE.UTF-8/UTF-8"
          ];

          extraLocaleSettings = {
            LC_TIME = "de_DE.UTF-8";
          };
        };

        system = {
          configurationRevision = lib.mkDefault (inputs.self.rev or inputs.self.dirtyRev or null);
        };

        environment = {
          enableAllTerminfo = true;
        };
      };
  };
}
