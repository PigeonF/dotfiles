{ nixpkgs, ... }:

let
  inherit (nixpkgs) lib;

  overlays = {
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
