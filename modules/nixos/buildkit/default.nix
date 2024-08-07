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
  _file = ./default.nix;

  options = {
    pigeonf.buildkit = {
      enable = lib.mkEnableOption "buildkit";
    };
  };

  config =
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
    lib.mkIf cfg.enable {
      virtualisation = {
        quadlet.containers = {
          "buildkit.internal".containerConfig =

            {
              image = "docker.io/moby/buildkit:master-rootless";
              volumes = [ "${buildkitdConfig}:/etc/buildkit/buildkitd.toml:ro" ];
              publishPorts = [ "3375" ];
              exec = "--oci-worker-no-process-sandbox --config /etc/buildkit/buildkitd.toml --addr tcp://:3375";
              addCapabilities = [ "CAP_SYS_ADMIN" ];
              networks = lib.mkIf hasRegistry [ "internal.network" ];
            };
        };
      };

      environment.etc."buildkit/buildkitd.toml" = {
        source = buildkitdConfig;
      };
    };
}
