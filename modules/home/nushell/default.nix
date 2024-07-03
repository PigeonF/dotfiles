{
  config,
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
        inherit (pkgs) nushell;

        nupmWrapper = pkgs.writeShellApplication {
          name = "nupm";

          runtimeInputs = [ nushell ];
          text = ''
            subcommand="''$1"
            shift

            args=()
            for arg in "$@"; do
              if [[ "$arg" == --* ]]; then
                args+=("$arg")
              else
                args+=("''${arg@Q}")
              fi
            done

            exec nu -n -I "$NUPM_HOME/modules" -c "use nupm/; nupm $subcommand ''${args[*]}"
          '';
        };
      };
    };
  };
}
