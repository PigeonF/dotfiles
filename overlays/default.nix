{ nixpkgs, ... }:

let
  inherit (nixpkgs) lib;

  overlays = {
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    reprotest = final: _: { reprotest = final.callPackage ./reprotest.nix { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
