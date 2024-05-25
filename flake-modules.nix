{ lib }:

let
  mkModules =
    module: directory:
    let
      inherit (builtins)
        attrNames
        attrValues
        listToAttrs
        map
        mapAttrs
        readDir
        ;
      inherit (lib) filterAttrs nameValuePair;

      readModulesIn =
        directory:
        let
          files = readDir (./modules + "/${directory}");
          folders = filterAttrs (_: kind: kind == "directory") files;
          names = attrNames folders;
          imports = map (dir: nameValuePair dir (import (./modules + "/${directory}/${dir}"))) names;
        in
        listToAttrs imports;

      modules = readModulesIn directory;
      f = name: value: (_: { flake."${module}"."${name}" = value; });
    in
    (mapAttrs f modules)
    // {
      default = _: {
        flake."${module}" = modules // {
          default = _: { imports = attrValues modules; };
        };
      };
    };

  home-modules = import ./modules/flake/home-modules.nix;
  homeModules = mkModules "homeModules" "home";
  nixosModules = mkModules "nixosModules" "nixos";
in

{
  inherit home-modules homeModules nixosModules;

  default = _: {
    imports = [
      home-modules
      homeModules.default
      nixosModules.default
    ];
  };
}
