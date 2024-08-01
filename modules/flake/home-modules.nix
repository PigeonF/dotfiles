{
  lib,
  flake-parts-lib,
  moduleLocation,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mapAttrsRecursive
    mkOption
    types
    ;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in

{
  _file = ./home-modules.nix;

  options = {
    flake = mkSubmoduleOptions {
      homeModules = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        default = { };
        apply = mapAttrsRecursive (
          path: v: {
            _file = "${toString moduleLocation}#homeModules.${concatStringsSep "." path}";
            imports = [ v ];
          }
        );
        description = ''
          home-manager modules.

          You may use this for reusable pieces of configuration, users, etc.
        '';
      };
    };
  };
}
