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
    cargo-nextest = final: _: {
      inherit (nixos-unstable-small.legacyPackages.${final.system}) cargo-nextest;
    };
    git-cliff = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) git-cliff; };
    go-task = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) go-task; };
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    jujutsu = final: _: { inherit (jujutsu.packages.${final.system}) jujutsu; };
    just = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) just; };
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
    harper = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) harper; };
    reprotest = final: _: { reprotest = final.callPackage ./reprotest { }; };
    reuse = final: _: {
      reuse = final.callPackage ./reuse {
        inherit (final.python3Packages)
          attrs
          binaryornot
          boolean-py
          buildPythonPackage
          debian
          freezegun
          jinja2
          license-expression
          poetry-core
          pytestCheckHook
          tomlkit
          ;
      };
    };
    starship = final: _: { inherit (nixos-unstable-small.legacyPackages.${final.system}) starship; };
    cargo-cross = final: _: { cargo-cross = final.callPackage ./cargo-cross { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
