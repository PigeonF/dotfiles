{ lib, ... }:

let
  readModulesIn =
    directory:
    let
      inherit (builtins)
        attrNames
        attrValues
        listToAttrs
        map
        readDir
        ;
      inherit (lib) filterAttrs nameValuePair;

      files = readDir directory;
      folders = filterAttrs (_: kind: kind == "directory") files;
      names = attrNames folders;
      imports = map (dir: nameValuePair dir (import (directory + "/${dir}"))) names;
      modules = listToAttrs imports;
    in
    modules // { default = _: { imports = attrValues modules; }; };
in

{
  flake.homeModules = readModulesIn ./home;
  flake.nixosModules = readModulesIn ./nixos;
}
