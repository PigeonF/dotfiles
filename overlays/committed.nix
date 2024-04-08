{
  darwin,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:

let
  version = "1.0.20";
  rev = "v${version}";
in

rustPlatform.buildRustPackage {
  pname = "committed";
  inherit version;

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    inherit rev;
    hash = "sha256-HqZYxV2YjnK7Q3A7B6yVFXME0oc3DZ4RfMkDGa2IQxA=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  doCheck = false;

  cargoHash = "sha256-AmAEGVWq6KxLtiHDGIFVcoP1Wck8z+P9mnDy0SSSJNM=";

  meta = {
    description = "Nitpicking commit history since beabf39";
    homepage = "https://github.com/crate-ci/committed";
    changelog = "https://github.com/crate-ci/committed/blob/${rev}/CHANGELOG.md";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
  };
}
