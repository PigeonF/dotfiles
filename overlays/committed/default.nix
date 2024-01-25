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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-prmMj8tVOm9P5EKkenero4YM9ccVU3JskTiHjup0oeQ=";
  };

  cargoHash = "sha256-WvRTRrnDeKJHFXxRlxrgyeFdNAyHVz75PH9Ymdat6zg=";

  meta = {
    description = "Nitpicking commit history since beabf39";
    homepage = "https://github.com/crate-ci/committed";
    changelog = "https://github.com/crate-ci/committed/blob/${src.rev}/CHANGELOG.md";
    license = builtins.attrValues {
      inherit
        (lib.licenses)
        asl20
        # or
        
        mit
        ;
    };
  };
}
