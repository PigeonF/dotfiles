{ config, lib, ... }:
let
  cfg = config.pigeonf.pypiserver;
in
{
  options = {
    pigeonf.pypiserver = {
      enable = lib.mkEnableOption "local pypi server";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.pigeonf.dns.enable;
        message = "pypi server will not be addressable without DNS setup";
      }
    ];

    virtualisation = {
      quadlet.containers = {
        "pypi.internal".containerConfig = {
          image = "docker.io/pypiserver/pypiserver:latest";
          # Run unauthenticated and allow overwriting packages.
          exec = "run --authenticate . --passwords . --overwrite";
          volumes = [ "pypi-packages:/data/packages" ];
          networks = [ "internal.network" ];
          noNewPrivileges = true;
        };
      };
    };
  };
}
