{
  lib,
  fetchurl,
  cmake,
}:
cmake.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "4.4.2";
    src = fetchurl {
      url = "https://cmake.org/files/v${lib.versions.majorMinor finalAttrs.version}/cmake-${finalAttrs.version}.tar.gz";
      hash = "sha256-HbnmHmC24IdMhjhjQLkQOC88XnW5+/tE0SIGMSmieJ0=";
    };

    patches =
      (lib.lists.ifilter0 (
        _: v: (lib.lists.last (lib.strings.splitString "/" v)) != "remove-impure-search-paths.patch"
      ) previousAttrs.patches)
      ++ [
        ./remove-impure-search-paths.patch
      ];
  }
)
