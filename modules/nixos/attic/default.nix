{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pigeonf.attic;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.attic = {
      enable = lib.mkEnableOption "local attic server";
      envFile = lib.mkOption {
        type = lib.types.path;
        description = "Environment file to load";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.pigeonf.dns.enable;
        message = "attic server will not be addressable without DNS setup";
      }
    ];

    virtualisation = {
      quadlet.containers = {
        "attic.internal".containerConfig =
          let
            config = pkgs.writeText "attic.toml" ''
              api-endpoint = "http://attic.internal/"

              [database]
              url = "sqlite:///data/attic.db?mode=rwc"

              [storage]
              type = "local"
              path = "/data/storage"

              [chunking]
              nar-size-threshold = 65536
              min-size = 16384
              avg-size = 65536
              max-size = 262144

              [compression]
              type = "zstd"

              [garbage-collection]
              interval = "12 hours"
            '';
          in
          {
            image = "ghcr.io/zhaofengli/attic:latest";
            runInit = true;
            # Run unauthenticated and allow overwriting packages.
            exec = "-f /attic/server.toml --mode monolithic --listen [::]:80";
            environmentFiles = [ cfg.envFile ];
            volumes = [
              "attic:/data"
              "${config}:/attic/server.toml:ro"
            ];
            networks = [ "internal.network" ];
            noNewPrivileges = true;
          };
      };
    };
  };
}
