{ config, lib, ... }:
let
  cfg = config.pigeonf.network;
  inherit (lib) mkDefault;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.network = {
      enable = lib.mkEnableOption "default network configuration";
      avahi.enable = lib.mkEnableOption "avahi";
      nftables.enable = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable nftables";
        type = lib.types.bool;
      };

      envFile = lib.mkOption {
        type = lib.types.path;
        description = "Environment file to load for network configuration";
      };

      networks = {
        obi-lan-kenobi = {
          enable = lib.mkEnableOption "Obi-Lan Kenobi Network";
          env = {
            pass = lib.mkOption {
              type = lib.types.str;
              description = "Password variable in pigeonf.network.envFile";
              default = "PASS_OBI_LAN_KENOBI";
            };
          };
        };

        eduroam = {
          enable = lib.mkEnableOption "Eduroam Network";

          env = {
            user = lib.mkOption {
              type = lib.types.str;
              description = "User variable in pigeonf.network.envFile";
              default = "USER_EDUROAM";
            };
            pass = lib.mkOption {
              type = lib.types.str;
              description = "Password variable in pigeonf.network.envFile";
              default = "PASS_EDUROAM";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      nftables.enable = mkDefault cfg.nftables.enable;
      firewall.enable = mkDefault true;
      useDHCP = mkDefault true;

      wireless = {
        enable = mkDefault true;
        userControlled.enable = mkDefault true;
        environmentFile = mkDefault cfg.envFile;
        scanOnLowSignal = mkDefault false;
        fallbackToWPA2 = mkDefault false;

        networks = {
          "Obi-Lan Kenobi" = lib.mkIf cfg.networks.obi-lan-kenobi.enable {
            psk = "@${cfg.networks.obi-lan-kenobi.env.pass}@";
          };

          eduroam = lib.mkIf cfg.networks.eduroam.enable {
            auth = ''
              key_mgmt=WPA-EAP
              eap=TTLS
              anonymous_identity="eduroam@ruhr-uni-bochum.de"

              identity="@${cfg.networks.eduroam.env.user}@@ruhr-uni-bochum.de"
              password="@${cfg.networks.eduroam.env.pass}@"

              phase2="auth=PAP"

              proto=RSN WPA
              mode=0
              pairwise=CCMP TKIP
              group=CCMP TKIP

              subject_match="/C=DE/ST=Nordrhein-Westfalen/L=Bochum/O=Ruhr-Universitaet Bochum/OU=Network Operation Center/CN=radius.ruhr-uni-bochum.de"
            '';
          };
        };
      };
    };

    services.avahi = lib.mkIf cfg.avahi.enable {
      enable = true;
      nssmdns4 = true;
    };
  };
}
