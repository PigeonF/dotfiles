{ config, lib, ... }:
let
  cfg = config.pigeonf.incus;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.incus = {
      enable = lib.mkEnableOption "incus";
    };
  };

  config =
    let
      ip = "10.109.165.1";
    in
    lib.mkIf cfg.enable {
      networking.firewall.interfaces.enp0s31f6.allowedTCPPorts = [ 8443 ];

      virtualisation.incus = {
        enable = true;
        ui.enable = true;
        preseed = {
          config = {
            "core.https_address" = ":8443";
          };
          networks = [
            {
              config = {
                "ipv4.address" = "${ip}/24";
                "ipv4.nat" = "true";
              };
              name = "incusbr0";
              type = "bridge";
            }
          ];
          profiles = [
            {
              devices = {
                eth0 = {
                  name = "eth0";
                  network = "incusbr0";
                  type = "nic";
                };
                root = {
                  path = "/";
                  pool = "default";
                  size = "64GiB";
                  type = "disk";
                };
              };
              name = "default";
            }
          ];
          storage_pools = [
            {
              config = {
                source = "/var/lib/incus/storage-pools/default";
              };
              driver = "btrfs";
              name = "default";
            }
          ];
        };
      };
      networking.firewall.trustedInterfaces = [ "incusbr0" ];

      services.dnsmasq.settings.server = [ "/incus/${ip}" ];
    };
}
