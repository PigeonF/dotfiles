{ config, lib, ... }:
{
  _file = ./default.nix;

  sops.secrets = {
    "${config.networking.domain}/acme" = {
      sopsFile = ./${config.networking.domain}/acme.env;
      format = "dotenv";
      restartUnits = [ "acme-${config.networking.domain}.service" ];
      mode = "400";
      owner = "nginx";
    };

    "${config.networking.domain}/forgejo" = lib.mkIf config.services.forgejo.enable {
      sopsFile = ./${config.networking.domain}/forgejo.env;
      format = "dotenv";
      restartUnits = [ "forgejo.service" ];
      mode = "400";
      owner = "${config.services.forgejo.user}";
    };
  };
}
