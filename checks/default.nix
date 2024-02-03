{ pkgs
, self
}:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // { inherit self; });
in
{
  nixpkgs-fmt = callPackage ./nixpkgs-fmt.nix { };
  deadnix = callPackage ./deadnix.nix { };
  statix = callPackage ./statix.nix { };
}
