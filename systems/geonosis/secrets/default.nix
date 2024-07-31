{
  sops.secrets = {
    "network" = {
      sopsFile = ./network.env;
      format = "dotenv";
      restartUnits = [ "wpa_supplicant.service" ];
    };

    "gitlab-runner-gitlab-com/environment" = {
      sopsFile = ./gitlab-runner-gitlab-com.env;
      format = "dotenv";
      restartUnits = [ "gitlab-runner.service" ];
    };

    "gitlab-runner-git-noc-rub-de/environment" = {
      sopsFile = ./gitlab-runner-git-noc-rub-de.env;
      format = "dotenv";
      restartUnits = [ "gitlab-runner.service" ];
    };
  };
}
