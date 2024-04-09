_:

{
  imports = [
    ./configs
    ./users.nix
  ];

  flake = {
    homeModules = {
      core =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          # Manual breaks often, so disable it.
          manual = {
            html.enable = false;
            manpages.enable = false;
            json.enable = false;
          };

          programs.home-manager.enable = true;

          home = {
            packages = [ pkgs.sops ];
            activation.sops-nix = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
              config.lib.dag.entryAfter [ "writeBoundary" ] ''
                /run/current-system/sw/bin/systemctl start --user sops-nix
              ''
            );
          };

          sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
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
