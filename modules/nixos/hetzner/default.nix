{ config, lib, ... }:
let
  cfg = config.pigeonf.hetzner.wan;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.hetzner.wan = {
      enable = lib.mkEnableOption "Hetzner Cloud WAN configuration";

      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the WAN interface";
        example = "enp1s0";
      };

      dhcp = lib.mkEnableOption "DHCP for Ipv4";

      addresses = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of addresses for the WAN interface";
        example = [ "2a01:4f8:c2c:c9d1::1/64" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.network.enable = true;
    networking = {
      # Not compatible with systemd.network.enable
      useDHCP = false;
    };

    systemd.network.networks."10-wan" = {
      address = cfg.addresses;

      linkConfig = {
        RequiredForOnline = "routable";
      };

      matchConfig = {
        Name = cfg.name;
      };

      networkConfig = {
        DHCP = lib.mkIf cfg.dhcp "ipv4";
      };

      # https://docs.hetzner.com/cloud/servers/static-configuration/

      routes = [
        { routeConfig.Gateway = "fe80::1"; }
        {
          routeConfig = {
            Destination = "172.31.1.1";
          };
        }
        {
          routeConfig = {
            Gateway = "172.31.1.1";
            GatewayOnLink = true;
          };
        }
        {
          routeConfig = {
            Destination = "172.16.0.0/12";
            Type = "unreachable";
          };
        }
        {
          routeConfig = {
            Destination = "192.168.0.0/16";
            Type = "unreachable";
          };
        }
        {
          routeConfig = {
            Destination = "10.0.0.0/8";
            Type = "unreachable";
          };
        }
        {
          routeConfig = {
            Destination = "fc00::/7";
            Type = "unreachable";
          };
        }
      ];
    };
  };
}
