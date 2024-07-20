{ config, lib, ... }:
let
  cfg = config.pigeonf.guix;
in
{
  options = {
    pigeonf.guix = {
      enable = lib.mkEnableOption "Use default guix configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    services.guix = {
      enable = true;
      gc.enable = true;
    };
  };
}
