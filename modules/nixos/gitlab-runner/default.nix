{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pigeonf.gitlab-runner;
  hasPodman = config.virtualisation.podman.enable;
in
{
  options = {
    pigeonf.gitlab-runner = {
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
              buildahEnabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable buildah for the runner";
              };
              buildkitEnabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable buildkit for the runner";
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
    virtualisation.docker.enable = lib.mkIf hasPodman (lib.mkForce false);

    services.gitlab-runner = {
      enable = cfg.runners != { };

      settings = {
        concurrent = 10;
        check_interval = 3;
        shutdown_timeout = 30;
      };

      services = builtins.mapAttrs (
        _: cfg:
        let
          moby = builtins.fetchGit {
            url = "https://github.com/moby/moby.git";
            ref = "master";
            rev = "ceefb7d0b9c5b6fbd1ea7511592a4ddb28ec4821";
          };
          defaultSeccomp = builtins.fromJSON (builtins.readFile "${moby}/profiles/seccomp/default.json");
          inherit (defaultSeccomp) syscalls;
          buildahSeccompFilter = builtins.toJSON (
            defaultSeccomp
            // {
              # Instead of adding SYS_CAP_ADMIN, we explicitly allow the syscalls that buildah
              # uses.
              syscalls = syscalls ++ [
                {
                  names = [
                    "mount"
                    "umount2"
                  ];
                  action = "SCMP_ACT_ALLOW";
                }
                {
                  names = [ "unshare" ];
                  action = "SCMP_ACT_ALLOW";
                  args = [
                    {
                      index = 0;
                      # CLONE_NEWNS
                      value = 131072;
                      op = "SCMP_CMP_EQ";
                    }
                    {
                      index = 0;
                      # CLONE_NEWUSER
                      value = 67239936;
                      op = "SCMP_CMP_EQ";
                    }
                    {
                      index = 0;
                      # CLONE_NEWNS | CLONE_NEWUTS
                      value = 268435456;
                      op = "SCMP_CMP_EQ";
                    }
                  ];
                }
              ];
            }
          );
          seccomp =
            if hasPodman then
              pkgs.writeText "seccomp.json" buildahSeccompFilter
            else
              # Due to https://gitlab.com/gitlab-org/gitlab-runner/-/issues/27235
              # we use the actual json contents instead of a file path
              lib.strings.escapeShellArg buildahSeccompFilter;
          buildkitdConfig = pkgs.writeText "buildkitd.toml" ''
            debug = true

            [registry."docker.io"]
              mirrors = ["mirror.gcr.io"]
          '';

          registrationFlags =
            [
              "--cache-dir /cache"
              "--docker-volumes /builds"
              "--docker-volumes /cache"
              "--docker-volumes /certs/client"
              "--output-limit 8192"
              "--env FF_NETWORK_PER_BUILD=1"
            ]
            ++ lib.optionals hasPodman [
              "--docker-host unix:///run/podman/podman.sock"
              "--docker-network-mode podman"
            ]
            ++ lib.optionals cfg.buildahEnabled [
              "--docker-devices /dev/fuse"
              "--docker-security-opt seccomp=${seccomp}"
            ]
            ++ lib.optionals cfg.buildkitEnabled [
              "--env DOCKER_DRIVER=overlay2"
              "--docker-services_privileged true"
              "--docker-allowed-privileged-services registry.gitlab.com/pigeonf/repository-helper/buildkit:buildx-stable-1"
              "--docker-allowed-privileged-services registry.gitlab.com/pigeonf/repository-helper/buildkit:buildx-stable-1-rootless"
              "--docker-volumes \"${buildkitdConfig}:/etc/buildkit/buildkitd.toml:ro\""
            ];
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
      after = [ "podman.socket" ];
      requires = [ "podman.socket" ];
      serviceConfig.SupplementaryGroups = "podman";
    };
  };
}
