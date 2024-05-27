{ config, lib, ... }:
let
  cfg = config.pigeonf.docker-rootless;
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
        };
      };
    };
  };
}
