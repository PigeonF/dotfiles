{ config, lib, ... }:
let
  cfg = config.pigeonf.podman;
in
{
  options = {
    pigeonf.podman = {
      enable = lib.mkEnableOption "Use podman as the container backend";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";

      podman = {
        enable = true;

        defaultNetwork.settings.dns_enabled = true;

        autoPrune = {
          enable = true;
          dates = "Tuesday 12:00";
          flags = [ "--all" ];
        };
      };
    };
  };
}
