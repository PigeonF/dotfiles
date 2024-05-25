{ lib }:

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

  homeManagerModules =
    let
      files = readDir ./modules/home;
      folders = filterAttrs (_: kind: kind == "directory") files;
      names = attrNames folders;
      imports = map (dir: nameValuePair dir (import (./modules/home + "/${dir}"))) names;
    in
    listToAttrs imports;

  homeModules =
    let
      f = name: value: (_: { flake.homeModules."${name}" = value; });
    in
    (mapAttrs f homeManagerModules)
    // {
      default = _: {
        flake.homeModules = homeManagerModules // {
          default = _: { imports = attrValues homeManagerModules; };
        };
      };
    };
in

{
  inherit homeModules;

  default = _: { imports = [ homeModules.default ]; };
}
