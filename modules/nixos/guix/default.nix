{ config, lib, ... }:
let
  cfg = config.pigeonf.guix;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.guix = {
      enable = lib.mkEnableOption "guix";
    };
  };

  config = lib.mkIf cfg.enable {
    services.guix = {
      enable = true;
      gc.enable = true;
    };
  };
}
