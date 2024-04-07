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
        home.sessionVariables = {
          XDG_CACHE_HOME = "$HOME/.cache";
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_DATA_HOME = "$HOME/.local/share";
          XDG_STATE_HOME = "$HOME/.local/state";

          XDG_BIN_HOME = "$HOME/.local/bin";
        };

        home.sessionPath = [ "$XDG_BIN_HOME" ];
      };

      common = _: { imports = [ ../users/common ]; };
    };
  };
}
