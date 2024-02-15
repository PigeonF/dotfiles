{ pkgs, self }:
let callPackage = pkgs.lib.callPackageWith (pkgs // { inherit self; });
in {
  nixfmt = callPackage ./nixfmt.nix { };
  deadnix = callPackage ./deadnix.nix { };
  statix = callPackage ./statix.nix { };
}
