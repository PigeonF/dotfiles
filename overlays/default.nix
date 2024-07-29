{ nixpkgs, nixos-unstable-small, ... }:

let
  inherit (nixpkgs) lib;

  overlays = {
    buildah = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) buildah; };
    git-cliff = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) git-cliff; };
    go-task = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) go-task; };
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    jujutsu = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) jujutsu; };
    neovim = final: _: {
      inherit (nixos-unstable-small.legacyPackages.${final.system}) neovim-unwrapped;
    };
    nushell = final: _: {
      nushell = final.callPackage ./nushell {
        inherit (final.darwin.apple_sdk.frameworks) Security AppKit Libsystem;
      };
    };
    markdownlint-cli2 = final: _: { markdownlint-cli2 = final.callPackage ./markdownlint-cli2 { }; };
    reprotest = final: _: { reprotest = final.callPackage ./reprotest { }; };
    starship = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) starship; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
