{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli2";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "DavidAnson";
    repo = "markdownlint-cli2";
    rev = "v${version}";
    hash = "sha256-z1rx60nRGrXsR0ZM5lj8zdSw1mv8FlKw8DZZJW51+HQ=";
  };

  npmDepsHash = "sha256-ztJejyyHmXG89TIBMiFWL5pMgnUYTUs2JSqgFqlpUjE=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  # Install the other output formatters as well
  dontNpmPrune = true;

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/DavidAnson/markdownlint-cli2/blob/${src.rev}/CHANGELOG.md";
    description = "A fast, flexible, configuration-based command-line interface for linting Markdown/CommonMark files with the markdownlint library";
    homepage = "https://github.com/DavidAnson/markdownlint-cli2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      pigeonf
    ];
  };
}
