{ config, lib, ... }:
let
  cfg = config.pigeonf.dns;
  base = "fd90:7c2e:b8d2:bf65";
  subnet = "${base}::/64";
  gateway = "${base}::1";
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
        server = [ "/internal/${gateway}" ];
        bind-interfaces = true;
        domain-needed = true;
        listen-address = [ "::1" ];
        local = [
          "/internal/"
          "/fritz.box/"
        ];
      };
    };

    virtualisation.quadlet = {
      networks = {
        internal.networkConfig = {
          subnets = [ "${subnet}" ];
          gateways = [ "${gateway}" ];
        };
      };
    };

    networking.firewall.interfaces."podman*".allowedUDPPorts = [ 53 ];
  };
}
