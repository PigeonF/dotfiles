{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-deduplicate-warnings";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aklFvvgPSRvZkcbed0s6PGt4b1wmlMAZaBS+X8Hj57o=";
  };

  cargoHash = "sha256-/T+dsatAAP5YTfwtMJiGZrjZSiK5NcaLYPk70xq/3G0=";

  # nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Deduplicate warning messages in the cargo json output";
    homepage = "https://github.com/swlynch99/cargo-deduplicate-warnings";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.pigeonf ];
    mainProgram = "cargo-deduplicate-warnings";
  };
}
