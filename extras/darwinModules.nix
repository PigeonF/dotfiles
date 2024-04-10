{
  lib,
  flake-parts-lib,
  moduleLocation,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mapAttrs
    mkOption
    types
    ;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in

{
  options = {
    flake = mkSubmoduleOptions {
      darwinModules = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        default = { };
        apply = mapAttrs (
          path: v: {
            _file = "${toString moduleLocation}#darwinModules.${concatStringsSep "." path}";
            imports = [ v ];
          }
        );
        description = ''
          nix-darwin modules.

          You may use this for reusable pieces of configuration, users, etc.
        '';
      };
    };
  };
}
