{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.nushell;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.nushell = {
    enable = mkEnableOption "PigeonF Nushell Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues {

        nushellFull = inputs.nixpkgs-nushell.legacyPackages.${pkgs.system}.nushellFull.override {
          additionalFeatures = p: p;
        };
      };
    };
  };
}
