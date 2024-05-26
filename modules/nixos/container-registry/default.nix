{ config, lib, ... }:
let
  cfg = config.pigeonf.container-registry;
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
          image = "docker.io/library/registry";
          environments = {
            REGISTRY_HTTP_ADDR = "0.0.0.0:80";
          };
          networks = [ "internal.network" ];
        };

        "registry-cache.internal".containerConfig = {
          image = "docker.io/library/registry";
          environments = {
            REGISTRY_HTTP_ADDR = "0.0.0.0:80";
            REGISTRY_PROXY_REMOTEURL = "https://registry-1.docker.io";
          };
          networks = [ "internal.network" ];
        };
      };
    };

    pigeonf = {
      virtualisation.containers.registries.settings = {
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
    };
  };
}
