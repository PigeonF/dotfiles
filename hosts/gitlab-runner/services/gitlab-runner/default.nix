# Due to
# - https://github.com/NixOS/nixpkgs/issues/158284
# - https://github.com/NixOS/nixpkgs/issues/282238
# we write our own version of the gitlab-runner module.
#
# Based on https://github.com/NixOS/nixpkgs/blob/f435abd55e8d95d299c525d23216b3907d803660/nixos/modules/services/continuous-integration/gitlab-runner.nix
{
  pkgs,
  config,
  ...
}: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  virtualisation.docker.enable = true;

  sops.secrets."gitlab-runner/environment" = {
    sopsFile = ./secrets.env;
    format = "dotenv";
    restartUnits = ["gitlab-runner.service"];
  };

  systemd.services.gitlab-runner = let
    config = ./config.toml;
    configPath = ''"$HOME"/.gitlab-runner/config.toml'';

    configureScript = pkgs.writeShellScriptBin "gitlab-runner-configure" ''
      mkdir -p "$(dirname ${configPath})"

      ${pkgs.gawk}/bin/awk '{
          for(varname in ENVIRON)
            gsub("@"varname"@", ENVIRON[varname])
          print
        }' "${config}" > "${configPath}"

      # make config file readable by service
      chown -R --reference="$HOME" "$(dirname ${configPath})"
    '';

    startScript = pkgs.writeShellScriptBin "gitlab-runner-start" ''
      export CONFIG_FILE=${configPath}
      exec ${pkgs.gitlab-runner} run --working-directory $HOME
    '';
  in {
    description = "Gitlab Runner";
    documentation = ["https://docs.gitlab.com/runner/"];
    after = ["network.target" "docker.service"];
    requires = ["docker.service"];
    wantedBy = ["multi-user.target"];
    environment = {
      HOME = "/var/lib/gitlab-runner";
    };
    reloadIfChanged = true;
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "gitlab-runner";
      SupplementaryGroups = "docker";
      ExecStartPre = "!${configureScript}/bin/gitlab-runner-configure";
      ExecStart = "${startScript}/bin/gitlab-runner-start";
      ExecReload = "!${configureScript}/bin/gitlab-runner-configure";
      EnvironmentFile = "/run/secrets/gitlab-runner/environment";
    };
  };

  # Enable periodic clear-docker-cache script
  systemd.services.gitlab-runner-clear-docker-cache = {
    description = "Prune gitlab-runner docker resources";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    serviceConfig.Type = "oneshot";

    path = [config.virtualisation.docker.package pkgs.gawk];

    script = ''
      ${pkgs.gitlab-runner}/bin/clear-docker-cache
    '';

    startAt = "weekly";
  };
}
