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
      packages = builtins.attrValues rec {
        nushellFull = inputs.nixpkgs-nushell.legacyPackages.${pkgs.system}.nushellFull.override {
          additionalFeatures = p: p;
        };

        nupmWrapper = pkgs.writeShellApplication {
          name = "nupm";

          runtimeInputs = [ nushellFull ];
          text = ''
            exec nu -n -I "$NUPM_HOME/modules" -c "use nupm/; nupm ''${*}"
          '';
        };
      };
    };
  };
}
