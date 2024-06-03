{ config, lib, ... }:
let
  cfg = config.pigeonf.incus;
in
{
  options = {
    pigeonf.incus = {
      enable = lib.mkEnableOption "Enable incus";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.incus.enable = true;
    networking.firewall.trustedInterfaces = [ "incusbr0" ];
  };
}
