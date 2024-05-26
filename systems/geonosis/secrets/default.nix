{
  sops.secrets."network" = {
    sopsFile = ./network.env;
    format = "dotenv";
    restartUnits = [ "wpa_supplicant.service" ];
  };

  sops.secrets."gitlab-runner/environment" = {
    sopsFile = ./gitlab-runner-default.env;
    format = "dotenv";
    restartUnits = [ "gitlab-runner.service" ];
  };

  sops.secrets."gitlab-runner/privileged/environment" = {
    sopsFile = ./gitlab-runner-privileged.env;
    format = "dotenv";
    restartUnits = [ "gitlab-runner.service" ];
  };
}
