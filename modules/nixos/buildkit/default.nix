{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pigeonf.buildkit;
  hasRegistry = config.pigeonf.container-registry.enable;
in
{
  options = {
    pigeonf.buildkit = {
      enable = lib.mkEnableOption "Enable buildkit";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      quadlet.containers = {
        "buildkit.internal".containerConfig =
          let
            buildkitdConfig = pkgs.writeText "buildkitd.toml" (
              lib.optionalString hasRegistry ''
                insecure-entitlements = [ "security.insecure" ]

                [registry."docker.io"]
                  mirrors = ["cache.internal"]

                [registry."registry.internal"]
                  http = true

                [registry."cache.internal"]
                  http = true
              ''
            );
          in
          {
            image = "docker.io/moby/buildkit:buildx-stable-1-rootless";
            volumes = [ "${buildkitdConfig}:/home/user/.config/buildkit/buildkitd.toml:ro" ];
            publishPorts = [ "[::1]:3375:3375" ];
            exec = "--oci-worker-no-process-sandbox --addr tcp://:3375";
            addCapabilities = [ "CAP_SYS_ADMIN" ];
            networks = lib.mkIf hasRegistry [ "internal.network" ];
          };
      };
    };
  };
}