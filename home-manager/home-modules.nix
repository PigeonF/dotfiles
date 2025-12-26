{ lib, ... }:
{
  _file = ./home-modules.nix;

  flake =
    let
      readDir =
        dir:
        lib.pipe (builtins.readDir dir) [
          (lib.filterAttrs (
            _path: kind: kind == "directory" || (kind == "regular" && lib.hasSuffix ".nix" _path)
          ))
          (lib.mapAttrsToList (path: _kind: lib.path.append dir path))
        ];
      homeModules = {
        dotter = ./modules/dotter.nix;
        programs = {
          imports = readDir ./programs;
        };
        presets = {
          imports = readDir ./presets;
        };
      };
      all = {
        imports = builtins.attrValues homeModules;
      };
      userModules =
        let
          mkUserModule = path: {
            imports = [
              all
              path
            ];
          };
        in
        {
          administrator = mkUserModule ./users/administrator.nix;
          developer = mkUserModule ./users/developer.nix;
          reviewer = mkUserModule ./users/reviewer.nix;
          root = mkUserModule ./users/root.nix;
        };
    in
    {
      homeModules =
        { }
        // homeModules
        // userModules
        // {
          inherit all;
        };
    };
}
