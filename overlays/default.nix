{ nixpkgs, nixos-unstable-small, ... }:

let
  inherit (nixpkgs) lib;

  overlays = {
    buildah = _: prev: { inherit (nixos-unstable-small.legacyPackages.${prev.system}) buildah; };
    git-cliff = final: _: { git-cliff = final.callPackage ./git-cliff { }; };
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    neovim = _: prev: {
      inherit (nixos-unstable-small.legacyPackages.${prev.system}) neovim-unwrapped;
    };
    nushell = _: prev: { inherit (nixos-unstable-small.legacyPackages.${prev.system}) nushell; };
    markdownlint-cli2 = final: _: { markdownlint-cli2 = final.callPackage ./markdownlint-cli2 { }; };
    reprotest = final: _: { reprotest = final.callPackage ./reprotest { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
