{ nixpkgs, nixpkgs-pigeonf, ... }:

let
  inherit (nixpkgs) lib;

  overlays = {
    committed = final: _: { inherit (nixpkgs-pigeonf.legacyPackages.${final.system}) committed; };

    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
