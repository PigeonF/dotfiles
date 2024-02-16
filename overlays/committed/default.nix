{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "committed";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    rev = "v${version}";
    hash = "sha256-HqZYxV2YjnK7Q3A7B6yVFXME0oc3DZ4RfMkDGa2IQxA=";
  };

  doCheck = false;

  cargoHash = "sha256-AmAEGVWq6KxLtiHDGIFVcoP1Wck8z+P9mnDy0SSSJNM=";

  meta = {
    description = "Nitpicking commit history since beabf39";
    homepage = "https://github.com/crate-ci/committed";
    changelog = "https://github.com/crate-ci/committed/blob/${src.rev}/CHANGELOG.md";
    license = builtins.attrValues {
      inherit (lib.licenses)
        asl20
        # or

        mit
        ;
    };
  };
}
