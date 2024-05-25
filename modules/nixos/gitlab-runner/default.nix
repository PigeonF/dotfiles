{ config, lib, ... }:
let
  cfg = config.pigeonf.gitlabRunner;
  hasPodman = config.virtualisation.podman.enable;
in
{
  options = {
    pigeonf.gitlabRunner = {
      enable = lib.mkEnableOption "enable gitlab-runner";
      privileged = lib.mkEnableOption "privileged mode for gitlab-runner";
      envFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to an environment file that is sourced before service
          configuration.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitlab-runner = {
      enable = true;
      clear-docker-cache.enable = true;

      settings = {
        concurrent = 10;
        check_interval = 3;
        shutdown_timeout = 30;
      };

      services = {
        default = {
          registrationConfigFile = cfg.envFile;
          description = "Default Runner";
          dockerImage = "docker.io/busybox";

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
            ++ lib.optionals cfg.privileged [ "--docker-privileged" ]
            ++ lib.optionals hasPodman [ "--docker-network-mode podman" ];
        };
      };
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
