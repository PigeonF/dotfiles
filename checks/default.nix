{ pkgs
, self
,
}:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // { inherit self; });
in
{
  alejandra = callPackage ./alejandra.nix { };
  deadnix = callPackage ./deadnix.nix { };
  statix = callPackage ./statix.nix { };
}
