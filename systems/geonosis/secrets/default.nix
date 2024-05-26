{
  sops.secrets = {
    "network" = {
      sopsFile = ./network.env;
      format = "dotenv";
      restartUnits = [ "wpa_supplicant.service" ];
    };

    "gitlab-runner/environment" = {
      sopsFile = ./gitlab-runner-default.env;
      format = "dotenv";
      restartUnits = [ "gitlab-runner.service" ];
    };

    "gitlab-runner/buildah/environment" = {
      sopsFile = ./gitlab-runner-buildah.env;
      format = "dotenv";
      restartUnits = [ "gitlab-runner.service" ];
    };
  };
}
