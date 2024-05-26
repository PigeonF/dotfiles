{ config, lib, ... }:
let
  cfg = config.pigeonf.container-registry;
  hasPodman = config.virtualisation.podman.enable;
in
{
  options = {
    pigeonf.container-registry = {
      enable = lib.mkEnableOption "enable local container registry";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      oci-containers.containers = {
        "registry.internal" = {
          image = "docker.io/library/registry";
          ports = [
            "127.0.0.1:5000:80"
            "[::1]:5000:80"
          ];
          environment = {
            REGISTRY_HTTP_ADDR = "0.0.0.0:80";
          };
        };

        "registry-cache.internal" = {
          image = "docker.io/library/registry";
          ports = [
            "127.0.0.1:5050:80"
            "[::1]:5050:80"
          ];
          environment = {
            REGISTRY_HTTP_ADDR = "0.0.0.0:80";
            REGISTRY_PROXY_REMOTEURL = "https://registry-1.docker.io";
          };
        };
      };
    };
  };
}
