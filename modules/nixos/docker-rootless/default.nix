{ config, lib, ... }:
let
  cfg = config.pigeonf.docker-rootless;
in
{
  options = {
    pigeonf.docker-rootless = {
      enable = lib.mkEnableOption "docker-rootless";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        rootless = {
          enable = true;
          setSocketVariable = true;

          daemon.settings = {
            iptables = !config.networking.nftables.enable;
            features = {
              containerd-snapshotter = true;
            };
          };
        };
      };
    };
  };
}
