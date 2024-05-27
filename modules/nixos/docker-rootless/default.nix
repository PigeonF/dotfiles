{ config, lib, ... }:
let
  cfg = config.pigeonf.docker-rootless;
  hasRegistry = config.pigeonf.container-registry.enable;
in
{
  options = {
    pigeonf.docker-rootless = {
      enable = lib.mkEnableOption "Enable docker-rootless";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        rootless = {
          enable = true;
          setSocketVariable = true;

          daemon.settings = {
            features = {
              containerd-snapshotter = true;
            };

            registry-mirrors = lib.mkIf hasRegistry [ "http://registry-cache.internal" ];
          };
        };
      };
    };
  };
}
