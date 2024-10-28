{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.pigeonf.kellnr;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.kellnr = {
      enable = lib.mkEnableOption "local kellnr server";
      envFile = lib.mkOption {
        type = lib.types.path;
        description = "Environment file to load";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = config.pigeonf.dns.enable;
        message = "kellnr server will not be addressable without DNS setup";
      }
    ];

    virtualisation = {
      quadlet.containers = {
        "kellnr.internal".containerConfig =
          let
            config = pkgs.writeText "cargo.toml" ''
              [registries.kellnr]
              index = "sparse+http://kellnr.internal/api/v1/crates/"
              credential-provider = ["cargo:token"]
            '';
          in
          {
            image = "ghcr.io/kellnr/kellnr:5";
            environmentFiles = [ cfg.envFile ];
            environments = {
              KELLNR_ORIGIN__HOSTNAME = "kellnr.internal";
              KELLNR_ORIGIN__PORT = 80;
              KELLNR_ORIGIN__PROTOCOL = "http";
            };
            volumes = [
              "kellner:/opt/kdata"
              "${config}:/usr/local/cargo/config.toml:ro"
            ];
            networks = [ "internal.network" ];
            noNewPrivileges = true;
          };
      };
    };
  };
}
