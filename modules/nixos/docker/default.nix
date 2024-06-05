{ config, lib, ... }:
let
  cfg = config.pigeonf.docker;
in
{
  options = {
    pigeonf.docker = {
      enable = lib.mkEnableOption "Enable docker";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          features = {
            containerd-snapshotter = true;
          };
          dns = [ "10.117.0.1" ];
        };
      };
    };

    services.dnsmasq.settings.interface = [ "docker0" ];
  };
}
