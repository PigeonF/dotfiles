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

  config = lib.mkIf cfg.enable {
    virtualisation.incus.enable = true;
    networking.firewall.trustedInterfaces = [ "incusbr0" ];
  };
}
