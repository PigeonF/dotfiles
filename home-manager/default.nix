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
            # sops-nix only adds the sops-nix service if there are secrets in the first place.
            activation.sops-nix = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && config.sops.secrets != { }) (
              config.lib.dag.entryAfter [ "writeBoundary" ] ''
                /run/current-system/sw/bin/systemctl start --user sops-nix
              ''
            );
          };

          sops.age.keyFile = lib.mkIf (
            config.sops.secrets != { }
          ) "${config.xdg.configHome}/sops/age/keys.txt";
        };

      xdg = {config, ...}: {
        xdg.enable = true;

        home.sessionVariables = {
          XDG_BIN_HOME = "$HOME/.local/bin";

          # Migrate these as soon as there is a corresponding entry in configs/
          DOTNET_CLI_HOME = "${config.xdg.cacheHome}/dotnet";
        };

        home.sessionPath = [ "$XDG_BIN_HOME" ];
      };
    };
  };
}
