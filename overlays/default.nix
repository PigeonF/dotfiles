{
  nixpkgs,
  nixos-unstable-small,
  git-cliff,
  ...
}:

let
  inherit (nixpkgs) lib;

  overlays = {
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    markdownlint-cli2 = final: _: { markdownlint-cli2 = final.callPackage ./markdownlint-cli2 { }; };
    nightlies = final: _: {
      inherit (nixos-unstable-small.legacyPackages.${final.system}) just;
      inherit (git-cliff.packages.${final.system}) git-cliff;
    };
    reprotest = final: _: { reprotest = final.callPackage ./reprotest { }; };
    reuse = final: _: {
      reuse = final.callPackage ./reuse {
        inherit (final.python3Packages)
          buildPythonPackage
          poetry-core
          sphinxHook
          furo
          myst-parser
          pbr
          sphinxcontrib-apidoc

          attrs
          binaryornot
          boolean-py
          click
          debian
          jinja2
          license-expression
          tomlkit

          freezegun
          pytestCheckHook
          ;
      };
    };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
