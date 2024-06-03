{ nixpkgs, ... }:

let
  inherit (nixpkgs) lib;

  overlays = {
    gitlab-ci-local = _: prev: {
      gitlab-ci-local = prev.gitlab-ci-local.overrideAttrs (
        _: _: { patches = [ ./gitlab-ci-local/ci-node-index.patch ]; }
      );
    };
    reprotest = final: _: { reprotest = final.callPackage ./reprotest { }; };
    markdownlint-cli2 = final: _: { markdownlint-cli2 = final.callPackage ./markdownlint-cli2 { }; };
    git-cliff = final: _: { git-cliff = final.callPackage ./git-cliff { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
