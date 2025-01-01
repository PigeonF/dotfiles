{
  nixpkgs,
  nixos-unstable-small,
  ...
}:

let
  inherit (nixpkgs) lib;

  overlays = {
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    nightlies =
      final: _:
      let
        unstablePkgs = nixos-unstable-small.legacyPackages.${final.system};
      in
      {
        inherit (unstablePkgs) git-cliff just jujutsu;
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
