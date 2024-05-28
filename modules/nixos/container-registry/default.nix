{ config, lib, ... }:
let
  cfg = config.pigeonf.container-registry;
  hasPodman = config.pigeonf.podman.enable;
  hasDocker = config.pigeonf.docker-rootless.enable;
in
{
  options = {
    pigeonf.container-registry = {
      enable = lib.mkEnableOption "enable local container registry";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      quadlet.containers = {
        "registry.internal".containerConfig = {
          image = "docker.io/library/registry:2";
          environments = {
            REGISTRY_HTTP_ADDR = ":80";
          };
          networks = [ "internal.network" ];
        };

        "registry-cache.internal".containerConfig = {
          image = "docker.io/library/registry:2";
          environments = {
            REGISTRY_HTTP_ADDR = ":80";
            REGISTRY_PROXY_REMOTEURL = "https://registry-1.docker.io";
          };
          networks = [ "internal.network" ];
        };
      };
    };

    pigeonf.virtualisation.containers.registries.settings = lib.mkIf hasPodman {
      registry = [
        {
          location = "*.internal";
          insecure = true;
        }
        {
          location = "docker.io";
          mirror = [
            {
              location = "registry-cache.internal";
              insecure = true;
            }
          ];
        }
      ];
    };

    virtualisation.docker.rootless.daemon.settings = lib.mkIf hasDocker {
      insecure-registries = [
        "registry.internal"
        "registry-cache.internal"
      ];
      registry-mirrors = [ "http://registry-cache.internal" ];
    };
  };
}
