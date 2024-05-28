{ config, lib, ... }:
let
  cfg = config.pigeonf.dns;
in
{
  options = {
    pigeonf.dns = {
      enable = lib.mkEnableOption "Use .internal DNS setup";
    };
  };

  config = lib.mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;

      settings = {
        server = [ "/internal/10.0.124.1" ];
        bind-interfaces = true;
        domain-needed = true;
        listen-address = [
          "127.0.0.1"
          "::1"
        ];
        local = [
          "/internal/"
          "/fritz.box/"
        ];
      };
    };

    virtualisation.quadlet = {
      networks = {
        internal.networkConfig = {
          subnets = [ "10.0.124.0/24" ];
        };
      };
    };

    networking.firewall.interfaces."podman*".allowedUDPPorts = [ 53 ];
  };
}
