{ lib, ... }:
{

  options = {
    pigeonf = {
      docker0 = lib.mkOption {
        type = lib.types.str;
        default = "10.117.0.1";
      };
    };
  };

  config = {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          bip = "10.117.0.1/16";
          ip = "127.0.0.1";
        };
      };
    };

    networking.firewall.trustedInterfaces = [ "docker0" ];
  };
}
