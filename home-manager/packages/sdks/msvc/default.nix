{ pkgs, ... }:
let
  fetchWinSDK = pkgs.callPackage ./fetch.nix { };
in
(fetchWinSDK {
  crt = "14.44.17.14";
  sdk = "10.0.26100";
  hash = "sha256-4+Xinc7pf4JCyO7gjACBpOcqh2ve0UAYczC96UZUuKE=";
})
// {
  passthru.fetch = fetchWinSDK;
}
