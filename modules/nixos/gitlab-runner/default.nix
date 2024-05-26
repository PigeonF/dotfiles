{ config, lib, ... }:
let
  cfg = config.pigeonf.gitlabRunner;
  hasPodman = config.virtualisation.podman.enable;
in
{
  options = {
    pigeonf.gitlabRunner = {
      enable = lib.mkEnableOption "enable gitlab-runner";

      runners = lib.mkOption {
        description = "Gitlab Runner runners";
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              description = lib.mkOption {
                type = lib.types.str;
                description = "Description of the runner";
              };
              privileged = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable privileged mode for the runner";
              };
              envFile = lib.mkOption {
                type = lib.types.path;
                description = "Environment file to load before registration";
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitlab-runner = {
      enable = (cfg.runners != { });
      clear-docker-cache.enable = true;

      settings = {
        concurrent = 10;
        check_interval = 3;
        shutdown_timeout = 30;
      };

      services = builtins.mapAttrs (
        _: cfg:
        let
          registrationFlags =
            [
              "--cache-dir /cache"
              "--docker-services-limit 5" # Fix warning about schema mismatch
              "--docker-volumes /builds"
              "--docker-volumes /cache"
              "--docker-volumes /certs/client"
              "--output-limit 8192"
              "--env FF_NETWORK_PER_BUILD=1"
              "--env DOCKER_DRIVER=overlay2"
            ]
            ++ lib.optionals hasPodman [ "--docker-network-mode podman" ]
            ++ lib.optionals cfg.privileged [ "--docker-privileged" ];
        in
        {
          registrationConfigFile = cfg.envFile;
          inherit (cfg) description;
          dockerImage = "docker.io/busybox";

          inherit registrationFlags;
        }
      ) cfg.runners;
    };

    systemd.services.gitlab-runner = lib.mkIf hasPodman {
      after = [
        "network.target"
        "podman.service"
      ];
      requires = [ "podman.service" ];
      serviceConfig.SupplementaryGroups = "podman";
    };
  };
}
