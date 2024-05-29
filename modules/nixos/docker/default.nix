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
        };
      };
    };
  };
}
