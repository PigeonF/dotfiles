_:

{
  flake.nixosModules.gitlab-runner =
    { config, lib, ... }:

    {
      options = {
        pigeonf.gitlabRunner.privileged = lib.mkEnableOption "privileged mode for gitlab-runner";
      };

      config = {
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
              registrationConfigFile = config.sops.secrets."gitlab-runner/environment".path;
              description = "Default Runner";
              dockerImage = "busybox";

              registrationFlags = [
                "--cache-dir /cache"
                "--docker-services-limit 5" # Fix warning about schema mismatch
                "--docker-volumes /builds"
                "--docker-volumes /cache"
                "--docker-volumes /certs/client"
                "--output-limit 8192"
              ] ++ lib.optionals config.pigeonf.gitlabRunner.privileged [ "--docker-privileged" ];
            };
          };
        };
      };
    };
}
