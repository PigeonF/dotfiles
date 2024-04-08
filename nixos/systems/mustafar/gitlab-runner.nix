{ config, ... }:

{
  sops.secrets."gitlab-runner/environment" = {
    sopsFile = ./gitlab-runner-default.env;
    format = "dotenv";
    restartUnits = [ "gitlab-runner.service" ];
  };

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
          "--docker-privileged"
          "--docker-services-limit 5" # Fix warning about schema mismatch
          "--docker-volumes /builds"
          "--docker-volumes /cache"
          "--docker-volumes /certs/client"
          "--output-limit 8192"
        ];
      };
    };
  };
}
