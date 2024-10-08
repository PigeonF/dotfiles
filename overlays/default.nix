{
  nixpkgs,
  jujutsu,
  nixos-unstable-small,
  ...
}:

let
  inherit (nixpkgs) lib;

  overlays = {
    buildah = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) buildah; };
    git-cliff = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) git-cliff; };
    go-task = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) go-task; };
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    jujutsu = final: _: { inherit (jujutsu.packages.${final.system}) jujutsu; };
    mdbook = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) mdbook; };
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
    reuse = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) reuse; };
    starship = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) starship; };
    cargo-cross = final: _: { cargo-cross = final.callPackage ./cargo-cross { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
