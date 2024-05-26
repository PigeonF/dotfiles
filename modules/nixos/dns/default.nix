{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pigeonf.dns;
  inherit (lib) types mkOption;
in
{
  options = {
    pigeonf.dns = {
      enable = lib.mkEnableOption "Use .internal DNS setup";

      virtualHosts = mkOption {
        default = { };
        type = types.attrsOf (
          types.submodule {
            options = {
              hostName = mkOption { type = types.str; };
              address = mkOption { type = types.str; };
              extraConfig = mkOption {
                type = types.str;
                default = "";
              };
            };
          }
        );
      };
    };
  };

  config =
    let
      virtualHosts = builtins.attrValues cfg.virtualHosts;
      mkVHostConfig = opts: ''
        http://${opts.hostName} {
          reverse_proxy ${opts.address}
          ${opts.extraConfig}
        }
      '';
      caddyfile = pkgs.writeTextDir "Caddyfile" ''
        ${lib.concatMapStringsSep "\n" mkVHostConfig virtualHosts}
      '';
    in
    lib.mkIf cfg.enable {
      services.dnsmasq = {
        enable = true;

        settings = {
          address = [ "/internal/10.0.123.2" ];
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
        containers = {
          caddy = {
            containerConfig = {
              image = "docker.io/library/caddy:latest";
              networks = [
                "ingress.network"
                "internal.network"
              ];
              volumes = [ "${caddyfile}/Caddyfile:/etc/caddy/Caddyfile:ro" ];
            };

            serviceConfig = {
              TimeoutStartSec = "60";
            };
          };
        };

        networks = {
          internal.networkConfig = { };

          ingress.networkConfig = {
            subnets = [ "10.0.123.1/30" ];
          };
        };
      };
    };
}
