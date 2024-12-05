{
  nixpkgs,
  nixos-unstable-small,
  nixpkgs-jujutsu,
  git-cliff,
  ...
}:

let
  inherit (nixpkgs) lib;

  overlays = {
    gitlab-ci-local = final: _: { gitlab-ci-local = final.callPackage ./gitlab-ci-local { }; };
    markdownlint-cli2 = final: _: { markdownlint-cli2 = final.callPackage ./markdownlint-cli2 { }; };
    nightlies =
      final: _:
      let
        unstablePkgs = nixos-unstable-small.legacyPackages.${final.system};
        gitCliffPkgs = git-cliff.packages.${final.system};
      in
      {
        inherit (unstablePkgs) just;
        inherit (gitCliffPkgs) git-cliff;
        inherit (nixpkgs-jujutsu.legacyPackages.${final.system}) jujutsu;
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
