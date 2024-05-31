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
    services.gitlab-runner = {
      enable = cfg.runners != { };

      settings = {
        concurrent = 4;
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
          mobySeccomp = builtins.fromJSON (builtins.readFile "${moby}/profiles/seccomp/default.json");

          buildahSeccompJson = builtins.toJSON (
            mobySeccomp
            // {
              # Instead of adding SYS_CAP_ADMIN, we explicitly allow the syscalls that buildah
              # uses.
              syscalls = mobySeccomp.syscalls ++ [
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
          buildahSeccomp =
            if hasPodman then
              pkgs.writeText "seccomp.json" buildahSeccompJson
            else
              # Due to https://gitlab.com/gitlab-org/gitlab-runner/-/issues/27235
              # we use the actual json contents instead of a file path
              lib.strings.escapeShellArg buildahSeccompJson;
          buildkitSeccompJson = builtins.toJSON (
            mobySeccomp
            // {
              syscalls = mobySeccomp.syscalls ++ [
                {
                  names = [
                    "clone"
                    "keyctl"
                    "mount"
                    "pivot_root"
                    "sethostname"
                    "umount2"
                    "unshare"
                  ];
                  action = "SCMP_ACT_ALLOW";
                }
              ];
            }
          );
          buildkitSeccomp =
            if hasPodman then
              pkgs.writeText "seccomp.json" buildkitSeccompJson
            else
              # Due to https://gitlab.com/gitlab-org/gitlab-runner/-/issues/27235
              # we use the actual json contents instead of a file path
              lib.strings.escapeShellArg buildkitSeccompJson;

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
              # "--env FF_USE_INIT_WITH_DOCKER_EXECUTOR=1"
            ]
            ++ lib.optionals hasPodman [
              "--docker-host unix:///run/podman/podman.sock"
              "--docker-network-mode podman"
            ]
            ++ lib.optionals cfg.buildahEnabled [
              "--docker-devices /dev/fuse"
              "--docker-security-opt seccomp=${buildahSeccomp}"
            ]
            ++ lib.optionals cfg.buildkitEnabled [
              "--docker-services-security-opt seccomp=${buildkitSeccomp}"
              "--docker-volumes /home/user/.local/share/buildkit"
              "--docker-volumes \"${buildkitdConfig}:/home/user/.config/buildkit/buildkitd.toml:ro\""
              # "--docker-allowed-services registry.gitlab.com/pigeonf/repository-helper/buildkit:rootless"
              # "--docker-allowed-services registry.gitlab.com/pigeonf/repository-helper/buildkit:rootless@sha256:*"
            ];
        in
        {
          registrationConfigFile = cfg.envFile;
          inherit (cfg) description;
          dockerImage = "docker.io/library/busybox:stable";

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
