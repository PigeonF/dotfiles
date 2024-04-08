{ ... }:

{
  imports = [
    ./configs
    ./users.nix
  ];

  flake = {
    homeModules = {
      core = _: {
        # Manual breaks often, so disable it.
        manual = {
          html.enable = false;
          manpages.enable = false;
          json.enable = false;
        };

        programs.home-manager.enable = true;
      };

      xdg = _: {
        xdg.enable = true;

        home.sessionVariables = {
          XDG_BIN_HOME = "$HOME/.local/bin";

          # Migrate these as soon as there is a corresponding entry in configs/
          DOTNET_CLI_HOME = "$XDG_CACHE_HOME/dotnet";
        };

        home.sessionPath = [ "$XDG_BIN_HOME" ];
      };
    };
  };
}
