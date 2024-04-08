{ nixpkgs, ... }:

let
  inherit (nixpkgs) lib;

  overlays = {
    committed = final: _: { committed = final.callPackage ./committed.nix { }; };

    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
