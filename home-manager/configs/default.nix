{ lib, ... }:

{
  flake.homeModules.configs =
    let
      contents = builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ];
    in
    lib.mapAttrs' (
      name: _: lib.nameValuePair (lib.strings.removeSuffix ".nix" name) (import ./${name})
    ) contents;
}
