{ pkgs, ... }:
let
  macOSXSDKVersions = builtins.fromJSON (builtins.readFile ./versions.json);
  fetchMacOSXSDK = pkgs.callPackage ./fetch.nix { };
in
(fetchMacOSXSDK macOSXSDKVersions."14")
// {
  passthru.fetch = fetchMacOSXSDK;
}
