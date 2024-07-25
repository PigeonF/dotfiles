{ config, lib, ... }:
let
  cfg = config.pigeonf.container-registry;
in
{
  options = {
    pigeonf.container-registry = {
      enable = lib.mkEnableOption "local container registry";
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
          volumes = [ "registry-images:/var/lib/registry" ];
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
            volumes = [ "registry-cache:/var/lib/registry" ];
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

    virtualisation.docker =
      let
        settings = {
          registry-mirrors = [ "http://cache.internal" ];

          insecure-registries = [
            "http://registry.internal"
            "http://cache.internal"
          ];
        };
      in
      {
        daemon = {
          inherit settings;
        };

        rootless.daemon = {
          inherit settings;
        };
      };
  };
}
