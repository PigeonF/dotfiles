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
            REGISTRY_HTTP_ADDR = "0.0.0.0:5000";
          };
          publishPorts = [ "5000" ];
          networks = [ "internal.network" ];
        };

        "registry-cache.internal".containerConfig = {
          image = "docker.io/library/registry";
          environments = {
            REGISTRY_HTTP_ADDR = "0.0.0.0:5000";
            REGISTRY_PROXY_REMOTEURL = "https://registry-1.docker.io";
          };
          publishPorts = [ "5000" ];
          networks = [ "internal.network" ];
        };
      };
    };

    pigeonf = {
      dns.virtualHosts = {
        "registry.internal" = {
          hostName = "registry.internal";
          address = "registry.internal:5000";
        };

        "registry-cache.internal" = {
          hostName = "registry-cache.internal";
          address = "registry-cache.internal:5000";
        };
      };

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
