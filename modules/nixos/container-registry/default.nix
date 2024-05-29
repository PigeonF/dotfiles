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
    assertions = [
      {
        assertion = config.pigeonf.dns.enable;
        message = "container registries will not be addressable without DNS setup";
      }
    ];

    virtualisation = {
      quadlet.containers = {
        "registry.internal".containerConfig = {
          image = "docker.io/library/registry:2";
          environments = {
            REGISTRY_HTTP_ADDR = ":80";
          };
          networks = [ "internal.network" ];
          noNewPrivileges = true;
        };

        "cache.internal" = {
          serviceConfig = {
            after = [ "network-online.target" ];
          };
          containerConfig = {
            image = "docker.io/library/registry:2";
            environments = {
              REGISTRY_HTTP_ADDR = ":80";
              REGISTRY_PROXY_REMOTEURL = "https://registry-1.docker.io";
            };
            networks = [ "internal.network" ];
            noNewPrivileges = true;
          };
        };
      };
    };

    pigeonf.virtualisation.containers.registries.settings = {
      registry = [
        {
          location = "registry.internal";
          insecure = true;
        }
        {
          location = "cache.internal";
          insecure = true;
        }
        {
          location = "docker.io";
          mirror = [
            {
              location = "cache.internal";
              insecure = true;
            }
          ];
        }
      ];
    };

    virtualisation.docker.rootless.daemon.settings = {
      registry-mirrors = [ "http://cache.internal" ];

      insecure-registries = [
        "http://registry.internal"
        "http://cache.internal"
      ];
    };
  };
}
