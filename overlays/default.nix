{
  nixpkgs,
  nixos-unstable-small,
  nixpkgs-gitlab-ci-local,
  ...
}:

let
  inherit (nixpkgs) lib;

  overlays = {
    buildah = _: prev: { inherit (nixos-unstable-small.legacyPackages.${prev.system}) buildah; };
    git-cliff = final: _: { git-cliff = final.callPackage ./git-cliff { }; };
    gitlab-ci-local = _: prev: {
      gitlab-ci-local =
        nixpkgs-gitlab-ci-local.legacyPackages.${prev.system}.gitlab-ci-local.overrideAttrs
          (
            _: prev: {
              patches = (prev.patches or [ ]) ++ [
                ./gitlab-ci-local/inputs-arrays.patch
                ./gitlab-ci-local/pr-1258.patch
                ./gitlab-ci-local/umask.patch
              ];
            }
          );
      # inherit (nixpkgs-gitlab-ci-local.legacyPackages.${prev.system}) gitlab-ci-local;
    };
    neovim = _: prev: {
      inherit (nixos-unstable-small.legacyPackages.${prev.system}) neovim-unwrapped;
    };
    nushell = _: prev: { inherit (nixos-unstable-small.legacyPackages.${prev.system}) nushell; };
    markdownlint-cli2 = final: _: { markdownlint-cli2 = final.callPackage ./markdownlint-cli2 { }; };
    reprotest = final: _: { reprotest = final.callPackage ./reprotest { }; };
  };
in

overlays // { default = lib.composeManyExtensions (builtins.attrValues overlays); }
