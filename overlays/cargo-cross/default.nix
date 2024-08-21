{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cross";
  version = "main";

  src = fetchFromGitHub {
    owner = "cross-rs";
    repo = "cross";
    rev = "d8631fe4f4e8bb4c4b24417a35544857fb42ee22";
    sha256 = "sha256-l1/8nrT/FyWSc3Wlk3QqU+oTlaXha/QVozrzzW1336g=";
  };

  cargoSha256 = "sha256-QoHzQZaBX9irsEZj6WN0rmP9/8uFojufudKI/ziC67M=";

  checkFlags = [ "--skip=docker::shared::tests::directories::test_host" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Zero setup cross compilation and cross testing";
    homepage = "https://github.com/cross-rs/cross";
    changelog = "https://github.com/cross-rs/cross/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ otavio ];
    mainProgram = "cross";
  };
}
