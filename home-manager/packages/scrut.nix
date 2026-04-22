{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "scrut";
  version = "0.4.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-97Ksc0be5ev5lDEX6QUsE+FvwziSphk/edVeJD17U2g=";
  };

  cargoHash = "sha256-fDK3L+VBssAYS1AXogeSCZo7Hz8kZxhPWiURUZ7NZW0=";

  # nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  checkFlags = [
    "--skip=executors"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scrut is a testing toolkit for CLI applications. A tool to scrutinize terminal programs without fuss.";
    homepage = "https://facebookincubator.github.io/scrut/";
    license = [
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.pigeonf ];
    mainProgram = "scrut";
  };
}
