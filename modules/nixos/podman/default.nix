{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.pigeonf.podman;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.podman = {
      enable = lib.mkEnableOption "podman";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";

      podman = {
        enable = true;
        dockerSocket.enable = !config.virtualisation.docker.enable;

        defaultNetwork.settings = {
          dns_enabled = true;
        };

        autoPrune = {
          enable = true;
          flags = [ "--all" ];
        };
      };
    };
    environment.systemPackages = [ pkgs.passt ];
  };
}
